-- Module Creation in Lua

-- A module is simply a table that is returned
-- This file demonstrates how to create a proper Lua module

-- Method 1: Basic module structure
local M = {}

M.version = "1.0.0"
M.author = "Your Name"

function M.greet(name)
    return "Hello, " .. name .. "!"
end

function M.add(a, b)
    return a + b
end

-- To use this module, you would save it as a file (e.g., mymodule.lua)
-- and load it with: local mymodule = require("mymodule")

-- Method 2: Module with private functions
local M2 = {}

-- Private function (local, not exported)
local function validate(x)
    return type(x) == "number"
end

-- Public function (exported)
function M2.square(x)
    if not validate(x) then
        error("Input must be a number")
    end
    return x * x
end

function M2.cube(x)
    if not validate(x) then
        error("Input must be a number")
    end
    return x * x * x
end

-- Method 3: Module with initialization
local M3 = {}

-- Module initialization code
local initialized = false

local function init()
    if not initialized then
        print("Initializing module...")
        initialized = true
    end
end

function M3.doSomething()
    init()  -- Ensure module is initialized
    print("Doing something...")
end

-- Method 4: Module with constants
local M4 = {}

M4.CONSTANTS = {
    MAX_SIZE = 100,
    MIN_SIZE = 1,
    DEFAULT_NAME = "Unknown"
}

function M4.isValidSize(size)
    return size >= M4.CONSTANTS.MIN_SIZE and size <= M4.CONSTANTS.MAX_SIZE
end

-- Method 5: Module with state
local M5 = {}

local state = {
    count = 0,
    items = {}
}

function M5.addItem(item)
    table.insert(state.items, item)
    state.count = state.count + 1
end

function M5.getCount()
    return state.count
end

function M5.getItems()
    return state.items
end

-- Method 6: Module with metatable
local M6 = {}
M6.__index = M6

function M6.new(name)
    local self = setmetatable({}, M6)
    self.name = name
    return self
end

function M6:greet()
    return "Hello from " .. self.name
end

-- Method 7: Module with documentation
local M7 = {}

--- Adds two numbers together
-- @param a number First number
-- @param b number Second number
-- @return number Sum of a and b
function M7.add(a, b)
    return a + b
end

--- Multiplies two numbers
-- @param a number First number
-- @param b number Second number
-- @return number Product of a and b
function M7.multiply(a, b)
    return a * b
end

-- Method 8: Complete module example
-- This is how you would structure a real module file

local Calculator = {}
Calculator._VERSION = "1.0.0"
Calculator._DESCRIPTION = "A simple calculator module"
Calculator._LICENSE = "MIT"

-- Private helper
local function checkNumber(x, name)
    if type(x) ~= "number" then
        error(name .. " must be a number")
    end
end

-- Public API
function Calculator.add(a, b)
    checkNumber(a, "a")
    checkNumber(b, "b")
    return a + b
end

function Calculator.subtract(a, b)
    checkNumber(a, "a")
    checkNumber(b, "b")
    return a - b
end

function Calculator.multiply(a, b)
    checkNumber(a, "a")
    checkNumber(b, "b")
    return a * b
end

function Calculator.divide(a, b)
    checkNumber(a, "a")
    checkNumber(b, "b")
    if b == 0 then
        error("Division by zero")
    end
    return a / b
end

-- Return the module
return Calculator

-- To use this module:
-- 1. Save it as calculator.lua
-- 2. In another file: local calc = require("calculator")
-- 3. Use it: print(calc.add(5, 3))
