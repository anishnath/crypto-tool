-- Debugging Techniques in Lua

-- Collection of practical debugging techniques

-- 1. Logging with levels
print("=== Logging Levels ===")

local LogLevel = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4
}

local currentLevel = LogLevel.INFO

local function log(level, ...)
    if level >= currentLevel then
        local prefix = {"[DEBUG]", "[INFO]", "[WARN]", "[ERROR]"}
        print(prefix[level], ...)
    end
end

log(LogLevel.DEBUG, "This won't print")
log(LogLevel.INFO, "Application started")
log(LogLevel.WARN, "Low memory")
log(LogLevel.ERROR, "Critical error")

-- 2. Breakpoint simulation
print("\n=== Breakpoint Simulation ===")

local function breakpoint(message)
    print("BREAKPOINT:", message or "")
    print("Stack trace:")
    print(debug.traceback())
    io.write("Press Enter to continue...")
    io.read()
end

local function processData(data)
    -- breakpoint("Before processing")
    local result = data * 2
    -- breakpoint("After processing, result = " .. result)
    return result
end

-- 3. Variable dumping
print("\n=== Variable Dumping ===")

local function dump(value, name, indent)
    indent = indent or 0
    name = name or "value"
    local prefix = string.rep("  ", indent)
    
    if type(value) == "table" then
        print(prefix .. name .. " = {")
        for k, v in pairs(value) do
            dump(v, tostring(k), indent + 1)
        end
        print(prefix .. "}")
    else
        print(prefix .. name .. " = " .. tostring(value) .. " (" .. type(value) .. ")")
    end
end

local data = {
    name = "Alice",
    age = 25,
    scores = {math = 90, science = 85}
}

dump(data, "data")

-- 4. Function call logging
print("\n=== Function Call Logging ===")

local function logCalls(func, name)
    return function(...)
        print("[CALL]", name, "with args:", ...)
        local results = {func(...)}
        print("[RETURN]", name, "returned:", table.unpack(results))
        return table.unpack(results)
    end
end

local function add(a, b)
    return a + b
end

local loggedAdd = logCalls(add, "add")
loggedAdd(5, 3)

-- 5. Conditional breakpoints
print("\n=== Conditional Breakpoints ===")

local function conditionalBreak(condition, message)
    if condition then
        print("CONDITION MET:", message)
        print(debug.traceback())
    end
end

for i = 1, 10 do
    conditionalBreak(i == 5, "i reached 5")
end

-- 6. Memory usage tracking
print("\n=== Memory Tracking ===")

local function getMemoryUsage()
    return collectgarbage("count")
end

local function trackMemory(func, name)
    local before = getMemoryUsage()
    func()
    local after = getMemoryUsage()
    print(string.format("%s used %.2f KB", name, after - before))
end

trackMemory(function()
    local t = {}
    for i = 1, 10000 do
        t[i] = i
    end
end, "Array creation")

-- 7. Execution time profiling
print("\n=== Profiling ===")

local function profile(func, name)
    local start = os.clock()
    local result = func()
    local elapsed = os.clock() - start
    print(string.format("%s: %.6f seconds", name, elapsed))
    return result
end

profile(function()
    local sum = 0
    for i = 1, 1000000 do
        sum = sum + i
    end
    return sum
end, "Sum calculation")

-- 8. State inspection
print("\n=== State Inspection ===")

local function inspectState(obj, name)
    print("State of", name .. ":")
    for k, v in pairs(obj) do
        print("  " .. k .. " =", v)
    end
end

local counter = {count = 0, max = 10}
inspectState(counter, "counter")

-- 9. Assertion with context
print("\n=== Contextual Assertions ===")

local function assertWithContext(condition, message, context)
    if not condition then
        local fullMessage = message
        if context then
            fullMessage = fullMessage .. "\nContext: " .. tostring(context)
        end
        error(fullMessage, 2)
    end
end

local function processUser(user)
    assertWithContext(type(user) == "table", "User must be a table", type(user))
    assertWithContext(user.name, "User must have name", user)
end

-- 10. Debug mode toggle
print("\n=== Debug Mode ===")

local DEBUG_MODE = true

local function debug_print(...)
    if DEBUG_MODE then
        print("[DEBUG]", ...)
    end
end

local function debug_dump(value, name)
    if DEBUG_MODE then
        dump(value, name)
    end
end

debug_print("Debug message")
debug_dump({x = 10, y = 20}, "point")

-- 11. Call stack analysis
print("\n=== Call Stack Analysis ===")

local function analyzeCallStack()
    local stack = {}
    local level = 2
    while true do
        local info = debug.getinfo(level, "Snl")
        if not info then break end
        table.insert(stack, {
            name = info.name or "?",
            source = info.short_src,
            line = info.currentline
        })
        level = level + 1
    end
    return stack
end

local function showCallStack()
    local stack = analyzeCallStack()
    print("Call stack:")
    for i, frame in ipairs(stack) do
        print(string.format("  %d: %s at %s:%d",
            i, frame.name, frame.source, frame.line))
    end
end

local function nested3()
    showCallStack()
end

local function nested2()
    nested3()
end

local function nested1()
    nested2()
end

nested1()

-- 12. Watch expressions
print("\n=== Watch Expressions ===")

local watches = {}

local function watch(name, getValue)
    watches[name] = getValue
end

local function checkWatches()
    print("Watch values:")
    for name, getValue in pairs(watches) do
        print("  " .. name .. " =", getValue())
    end
end

local x = 10
watch("x", function() return x end)
watch("x*2", function() return x * 2 end)

checkWatches()
x = 20
checkWatches()
