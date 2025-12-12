-- Using require() to load modules in Lua

-- require() is Lua's built-in function for loading modules
-- It searches for modules in package.path

-- Example 1: Loading a built-in module
local math = require("math")
print("Pi:", math.pi)
print("Square root of 16:", math.sqrt(16))

-- Example 2: Loading string library
local string = require("string")
print("Uppercase:", string.upper("hello"))

-- Example 3: Creating a simple module file
-- In a real scenario, this would be in a separate file: mymath.lua
--[[
-- File: mymath.lua
local M = {}

function M.add(a, b)
    return a + b
end

function M.multiply(a, b)
    return a * b
end

M.version = "1.0"

return M
]]

-- Then you would load it with:
-- local mymath = require("mymath")
-- print(mymath.add(5, 3))

-- Example 4: Module with private functions
--[[
-- File: calculator.lua
local M = {}

-- Private function
local function validate(x)
    return type(x) == "number"
end

-- Public functions
function M.square(x)
    if not validate(x) then
        error("Input must be a number")
    end
    return x * x
end

function M.cube(x)
    if not validate(x) then
        error("Input must be a number")
    end
    return x * x * x
end

return M
]]

-- Usage:
-- local calc = require("calculator")
-- print(calc.square(5))

-- Example 5: Module caching
-- require() caches modules, so they're only loaded once
print("\n=== Module Caching ===")
print("Loading math module first time")
local math1 = require("math")
print("Loading math module second time")
local math2 = require("math")
print("Same module?", math1 == math2)  -- true

-- Example 6: package.path
-- Shows where Lua looks for modules
print("\n=== Package Path ===")
print("package.path:", package.path)

-- You can add custom paths:
-- package.path = package.path .. ";./mymodules/?.lua"

-- Example 7: Module with initialization
--[[
-- File: database.lua
local M = {}

local connection = nil

function M.connect(host)
    print("Connecting to " .. host)
    connection = {host = host, connected = true}
    return connection
end

function M.disconnect()
    if connection then
        print("Disconnecting from " .. connection.host)
        connection = nil
    end
end

function M.isConnected()
    return connection ~= nil
end

return M
]]

-- Usage:
-- local db = require("database")
-- db.connect("localhost")
-- print("Connected?", db.isConnected())

-- Example 8: Reloading a module
-- To reload a module, remove it from package.loaded
print("\n=== Reloading Modules ===")
package.loaded["math"] = nil  -- Remove from cache
local math3 = require("math")  -- Will reload
print("Reloaded math module")

-- Example 9: Module with dependencies
--[[
-- File: logger.lua
local string = require("string")
local os = require("os")

local M = {}

function M.log(message)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    print("[" .. timestamp .. "] " .. string.upper(message))
end

return M
]]

-- Example 10: Conditional module loading
local function loadModule(name)
    local success, module = pcall(require, name)
    if success then
        print("Loaded module:", name)
        return module
    else
        print("Failed to load module:", name)
        return nil
    end
end

local json = loadModule("json")  -- May or may not exist
local math = loadModule("math")  -- Should exist

-- Example 11: Module with configuration
--[[
-- File: config.lua
local M = {}

M.settings = {
    debug = false,
    timeout = 30,
    maxRetries = 3
}

function M.get(key)
    return M.settings[key]
end

function M.set(key, value)
    M.settings[key] = value
end

return M
]]

-- Usage:
-- local config = require("config")
-- config.set("debug", true)
-- print("Debug mode:", config.get("debug"))
