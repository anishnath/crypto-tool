-- Exercise: Debugging
-- TODO: Complete the following exercises

-- 1. Create a logging function with levels
local LogLevel = {DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4}
local currentLevel = LogLevel.INFO

local function log(level, message)
    -- your code here
    -- only print if level >= currentLevel
end

-- log(LogLevel.DEBUG, "Debug message")
-- log(LogLevel.ERROR, "Error message")

-- 2. Create a function to dump table contents
local function dumpTable(t, indent)
    -- your code here
    -- recursively print table contents
    -- handle nested tables
end

-- local data = {name = "Alice", scores = {math = 90, science = 85}}
-- dumpTable(data)

-- 3. Create a function call tracker
local function trackCalls(func, name)
    -- your code here
    -- wrap function to log calls and returns
end

-- local function add(a, b) return a + b end
-- local trackedAdd = trackCalls(add, "add")
-- trackedAdd(5, 3)

-- 4. Create a performance timer
local function timeFunction(func, name)
    -- your code here
    -- measure execution time using os.clock()
end

-- timeFunction(function()
--     local sum = 0
--     for i = 1, 1000000 do sum = sum + i end
-- end, "sum")

-- 5. Create a breakpoint function
local function breakpoint(message)
    -- your code here
    -- print message and stack trace
    -- optionally wait for user input
end

-- local function process(x)
--     breakpoint("Before calculation")
--     return x * 2
-- end

-- 6. Create an assertion with context
local function assertWithContext(condition, message, context)
    -- your code here
    -- throw error with message and context if condition is false
end

-- assertWithContext(5 > 3, "Math error", {a = 5, b = 3})

-- 7. Create a memory usage tracker
local function trackMemory(func, name)
    -- your code here
    -- measure memory before and after function call
    -- use collectgarbage("count")
end

-- trackMemory(function()
--     local t = {}
--     for i = 1, 10000 do t[i] = i end
-- end, "array")

-- 8. Create a call stack analyzer
local function getCallStack()
    -- your code here
    -- use debug.getinfo() to build call stack
    -- return array of stack frames
end

-- local stack = getCallStack()
-- for i, frame in ipairs(stack) do
--     print(i, frame.name, frame.source, frame.line)
-- end
