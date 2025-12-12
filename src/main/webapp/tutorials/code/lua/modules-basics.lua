-- Creating Modules in Lua

-- A module is just a table that contains functions and variables
-- This is a simple module pattern

-- Method 1: Simple module table
local mymodule = {}

function mymodule.sayHello(name)
    print("Hello, " .. name .. "!")
end

function mymodule.add(a, b)
    return a + b
end

mymodule.version = "1.0"

-- Use the module
mymodule.sayHello("World")
print("Sum:", mymodule.add(5, 3))
print("Version:", mymodule.version)

-- Method 2: Module with local (private) functions
local mathutils = {}

-- Private function (local)
local function validate(x)
    return type(x) == "number"
end

-- Public functions
function mathutils.square(x)
    if not validate(x) then
        error("Input must be a number")
    end
    return x * x
end

function mathutils.cube(x)
    if not validate(x) then
        error("Input must be a number")
    end
    return x * x * x
end

print("\nMath utils:")
print("Square of 5:", mathutils.square(5))
print("Cube of 3:", mathutils.cube(3))
-- print(validate(5))  -- Error: validate is not accessible

-- Method 3: Module with constructor pattern
local function createCounter()
    local count = 0  -- Private variable
    
    local counter = {}
    
    function counter.increment()
        count = count + 1
        return count
    end
    
    function counter.decrement()
        count = count - 1
        return count
    end
    
    function counter.getValue()
        return count
    end
    
    return counter
end

local counter1 = createCounter()
local counter2 = createCounter()

print("\nCounters:")
print("Counter1:", counter1.increment())
print("Counter1:", counter1.increment())
print("Counter2:", counter2.increment())
print("Counter1 value:", counter1.getValue())
print("Counter2 value:", counter2.getValue())

-- Method 4: Module with metatable
local StringUtils = {}
StringUtils.__index = StringUtils

function StringUtils.new()
    return setmetatable({}, StringUtils)
end

function StringUtils.reverse(str)
    return string.reverse(str)
end

function StringUtils.capitalize(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

function StringUtils.split(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

print("\nString utils:")
print("Reverse:", StringUtils.reverse("hello"))
print("Capitalize:", StringUtils.capitalize("hello"))
local parts = StringUtils.split("a,b,c", ",")
print("Split:", table.concat(parts, " | "))

-- Method 5: Module with namespace
local App = {}
App.Utils = {}
App.Models = {}

function App.Utils.log(message)
    print("[LOG] " .. message)
end

function App.Models.User(name)
    return {name = name}
end

App.Utils.log("Application started")
local user = App.Models.User("Alice")
print("User:", user.name)

-- Method 6: Returning a module
local function createLogger(prefix)
    local logger = {}
    
    function logger.info(message)
        print("[" .. prefix .. " INFO] " .. message)
    end
    
    function logger.error(message)
        print("[" .. prefix .. " ERROR] " .. message)
    end
    
    return logger
end

local appLogger = createLogger("APP")
local dbLogger = createLogger("DB")

appLogger.info("Application started")
dbLogger.error("Connection failed")
