-- Debugging Basics in Lua

-- Lua provides the debug library for debugging

print("=== debug.getinfo() ===")

local function myFunction()
    local info = debug.getinfo(1)
    print("Function name:", info.name or "anonymous")
    print("Source:", info.short_src)
    print("Line defined:", info.linedefined)
    print("What:", info.what)
end

myFunction()

-- debug.traceback() - Get stack trace
print("\n=== debug.traceback() ===")

local function level3()
    print(debug.traceback("Stack trace from level3:"))
end

local function level2()
    level3()
end

local function level1()
    level2()
end

level1()

-- debug.getlocal() - Get local variables
print("\n=== debug.getlocal() ===")

local function showLocals()
    local x = 10
    local y = 20
    local name = "test"
    
    local i = 1
    while true do
        local name, value = debug.getlocal(1, i)
        if not name then break end
        print(i, name, "=", value)
        i = i + 1
    end
end

showLocals()

-- debug.getupvalue() - Get upvalues (closure variables)
print("\n=== debug.getupvalue() ===")

local function createCounter()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

local counter = createCounter()
local name, value = debug.getupvalue(counter, 1)
print("Upvalue:", name, "=", value)

-- Print debugging
print("\n=== Print Debugging ===")

local function debugPrint(...)
    print("[DEBUG]", ...)
end

local function calculate(x, y)
    debugPrint("calculate called with", x, y)
    local result = x + y
    debugPrint("result:", result)
    return result
end

calculate(5, 3)

-- Conditional debugging
print("\n=== Conditional Debugging ===")

local DEBUG = true

local function log(...)
    if DEBUG then
        print("[LOG]", ...)
    end
end

local function process(data)
    log("Processing:", data)
    -- do work
    log("Done processing")
end

process("test data")

-- Assertion debugging
print("\n=== Assertion Debugging ===")

local function divide(a, b)
    assert(type(a) == "number", "a must be a number")
    assert(type(b) == "number", "b must be a number")
    assert(b ~= 0, "b cannot be zero")
    return a / b
end

print("10 / 2 =", divide(10, 2))

-- Table inspection
print("\n=== Table Inspection ===")

local function printTable(t, indent)
    indent = indent or 0
    local prefix = string.rep("  ", indent)
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(prefix .. k .. ":")
            printTable(v, indent + 1)
        else
            print(prefix .. k .. " = " .. tostring(v))
        end
    end
end

local data = {
    name = "Alice",
    age = 25,
    address = {
        city = "New York",
        zip = "10001"
    }
}

printTable(data)

-- Function call tracking
print("\n=== Function Call Tracking ===")

local callCount = {}

local function trackCalls(func, name)
    return function(...)
        callCount[name] = (callCount[name] or 0) + 1
        print("[CALL]", name, "called", callCount[name], "times")
        return func(...)
    end
end

local function add(a, b)
    return a + b
end

local trackedAdd = trackCalls(add, "add")
trackedAdd(1, 2)
trackedAdd(3, 4)
trackedAdd(5, 6)

-- Performance timing
print("\n=== Performance Timing ===")

local function timeFunction(func, ...)
    local start = os.clock()
    local result = func(...)
    local elapsed = os.clock() - start
    print(string.format("Execution time: %.6f seconds", elapsed))
    return result
end

local function slowFunction()
    local sum = 0
    for i = 1, 1000000 do
        sum = sum + i
    end
    return sum
end

timeFunction(slowFunction)

-- Variable watching
print("\n=== Variable Watching ===")

local function createWatchedVariable(initialValue)
    local value = initialValue
    return {
        get = function()
            print("[WATCH] Reading value:", value)
            return value
        end,
        set = function(newValue)
            print("[WATCH] Changing from", value, "to", newValue)
            value = newValue
        end
    }
end

local x = createWatchedVariable(10)
x.set(20)
print("Value:", x.get())

-- Error location tracking
print("\n=== Error Location ===")

local function whereAmI()
    local info = debug.getinfo(2, "Sl")
    return info.short_src .. ":" .. info.currentline
end

local function someFunction()
    print("Called from:", whereAmI())
end

someFunction()
