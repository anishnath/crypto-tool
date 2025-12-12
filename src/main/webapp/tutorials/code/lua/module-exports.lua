-- Module Exports in Lua

-- Different ways to export functions and values from a module

-- Method 1: Export individual functions
local M = {}

M.greet = function(name)
    return "Hello, " .. name
end

M.farewell = function(name)
    return "Goodbye, " .. name
end

-- Method 2: Export with function syntax
local M2 = {}

function M2.add(a, b)
    return a + b
end

function M2.multiply(a, b)
    return a * b
end

-- Method 3: Export constants
local M3 = {}

M3.VERSION = "1.0.0"
M3.MAX_SIZE = 100
M3.DEFAULT_NAME = "Unknown"

function M3.getVersion()
    return M3.VERSION
end

-- Method 4: Export with namespace
local M4 = {}

M4.math = {}
M4.math.add = function(a, b) return a + b end
M4.math.subtract = function(a, b) return a - b end

M4.string = {}
M4.string.reverse = function(s) return string.reverse(s) end
M4.string.upper = function(s) return string.upper(s) end

-- Method 5: Selective exports (only export what you want)
local M5 = {}

-- Private function (not exported)
local function privateHelper()
    return "This is private"
end

-- Public function (exported)
function M5.publicFunction()
    return "This is public: " .. privateHelper()
end

-- Method 6: Export class-like structure
local M6 = {}
M6.__index = M6

function M6.new(name, age)
    local self = setmetatable({}, M6)
    self.name = name
    self.age = age
    return self
end

function M6:introduce()
    return "I'm " .. self.name .. ", " .. self.age .. " years old"
end

-- Method 7: Export with factory pattern
local M7 = {}

function M7.createCounter(initial)
    local count = initial or 0
    
    return {
        increment = function()
            count = count + 1
            return count
        end,
        decrement = function()
            count = count - 1
            return count
        end,
        getValue = function()
            return count
        end
    }
end

-- Method 8: Export with configuration
local M8 = {}

M8.config = {
    debug = false,
    timeout = 30,
    maxRetries = 3
}

function M8.configure(options)
    for key, value in pairs(options) do
        M8.config[key] = value
    end
end

function M8.getConfig(key)
    return M8.config[key]
end

-- Method 9: Export with multiple return values
local M9 = {}

function M9.divmod(a, b)
    return math.floor(a / b), a % b
end

function M9.minmax(numbers)
    local min, max = numbers[1], numbers[1]
    for i = 2, #numbers do
        if numbers[i] < min then min = numbers[i] end
        if numbers[i] > max then max = numbers[i] end
    end
    return min, max
end

-- Method 10: Complete module with all exports
local StringUtils = {}

-- Module metadata
StringUtils._VERSION = "1.0.0"
StringUtils._DESCRIPTION = "String utility functions"

-- Private helpers
local function isString(s)
    return type(s) == "string"
end

-- Public functions
function StringUtils.reverse(s)
    if not isString(s) then
        error("Input must be a string")
    end
    return string.reverse(s)
end

function StringUtils.capitalize(s)
    if not isString(s) then
        error("Input must be a string")
    end
    return string.upper(string.sub(s, 1, 1)) .. string.sub(s, 2)
end

function StringUtils.split(s, delimiter)
    if not isString(s) then
        error("Input must be a string")
    end
    local result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function StringUtils.trim(s)
    if not isString(s) then
        error("Input must be a string")
    end
    return s:match("^%s*(.-)%s*$")
end

-- Export constants
StringUtils.EMPTY = ""
StringUtils.SPACE = " "

-- Return the module
return StringUtils

-- Usage examples (in another file):
-- local utils = require("stringutils")
-- print(utils.reverse("hello"))
-- print(utils.capitalize("world"))
-- local parts = utils.split("a,b,c", ",")
