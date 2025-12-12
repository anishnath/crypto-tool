-- debug.traceback() in Lua

-- debug.traceback() provides stack trace information

print("=== Basic Stack Trace ===")

local function showTrace()
    print(debug.traceback())
end

showTrace()

-- Stack trace with message
print("\n=== Stack Trace with Message ===")

local function errorWithTrace()
    print(debug.traceback("Error occurred here"))
end

errorWithTrace()

-- Stack trace at different levels
print("\n=== Stack Trace Levels ===")

local function level3()
    print("Level 3:")
    print(debug.traceback("", 0))  -- Full trace
end

local function level2()
    level3()
end

local function level1()
    level2()
end

level1()

-- Custom error handler with traceback
print("\n=== Error Handler with Traceback ===")

local function errorHandler(err)
    return debug.traceback("Error: " .. tostring(err), 2)
end

local function faultyFunction()
    error("Something went wrong")
end

local ok, result = xpcall(faultyFunction, errorHandler)
if not ok then
    print(result)
end

-- Traceback in nested calls
print("\n=== Nested Call Traceback ===")

local function deepFunction()
    error("Deep error")
end

local function middleFunction()
    deepFunction()
end

local function topFunction()
    middleFunction()
end

local ok, err = xpcall(topFunction, function(e)
    return debug.traceback(e, 2)
end)

if not ok then
    print("Traceback:")
    print(err)
end

-- Formatted traceback
print("\n=== Formatted Traceback ===")

local function formatTraceback(err)
    local trace = debug.traceback(err, 2)
    local lines = {}
    for line in trace:gmatch("[^\n]+") do
        table.insert(lines, "  " .. line)
    end
    return table.concat(lines, "\n")
end

xpcall(function()
    error("Formatted error")
end, function(e)
    print("Error with formatted trace:")
    print(formatTraceback(e))
    return e
end)

-- Traceback with context
print("\n=== Traceback with Context ===")

local function contextTraceback(context)
    return function(err)
        local trace = debug.traceback(err, 2)
        return string.format("[%s]\n%s", context, trace)
    end
end

xpcall(function()
    error("Database error")
end, contextTraceback("DATABASE"))

-- Stack inspection
print("\n=== Stack Inspection ===")

local function inspectStack()
    local level = 2
    print("Stack frames:")
    while true do
        local info = debug.getinfo(level, "Snl")
        if not info then break end
        print(string.format("  %d: %s (%s:%d)",
            level - 1,
            info.name or "?",
            info.short_src,
            info.currentline))
        level = level + 1
    end
end

local function caller()
    inspectStack()
end

caller()

-- Traceback filtering
print("\n=== Filtered Traceback ===")

local function filterTraceback(err)
    local trace = debug.traceback(err, 2)
    local filtered = {}
    for line in trace:gmatch("[^\n]+") do
        if not line:match("%(tail call%)") then
            table.insert(filtered, line)
        end
    end
    return table.concat(filtered, "\n")
end

-- Traceback with local variables
print("\n=== Traceback with Locals ===")

local function tracebackWithLocals(err)
    local trace = {debug.traceback(err, 2)}
    local level = 3
    while true do
        local info = debug.getinfo(level, "Snl")
        if not info then break end
        
        table.insert(trace, string.format("\nLocals at %s:", info.name or "?"))
        local i = 1
        while true do
            local name, value = debug.getlocal(level, i)
            if not name then break end
            table.insert(trace, string.format("  %s = %s", name, tostring(value)))
            i = i + 1
        end
        level = level + 1
    end
    return table.concat(trace, "\n")
end

xpcall(function()
    local x = 10
    local y = 20
    error("Error with locals")
end, function(e)
    print(tracebackWithLocals(e))
    return e
end)
