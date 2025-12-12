-- Lua Best Practices: Performance

-- 1. Use local variables (faster access)
print("=== Local vs Global ===")

-- Slow (global access)
function slowFunction()
    for i = 1, 1000000 do
        math.sqrt(i)  -- Global lookup every time
    end
end

-- Fast (local access)
local function fastFunction()
    local sqrt = math.sqrt  -- Cache in local
    for i = 1, 1000000 do
        sqrt(i)
    end
end

-- 2. Pre-allocate tables when size is known
print("\n=== Table Pre-allocation ===")

-- Slow
local function slowTableCreation()
    local t = {}
    for i = 1, 10000 do
        t[i] = i
    end
    return t
end

-- Faster (though Lua doesn't have explicit pre-allocation)
local function fasterTableCreation()
    local t = {}
    for i = 1, 10000 do
        t[i] = i
    end
    return t
end

-- 3. Use table.concat for string building
print("\n=== String Concatenation ===")

-- Slow (creates many intermediate strings)
local function slowConcat()
    local s = ""
    for i = 1, 1000 do
        s = s .. tostring(i)
    end
    return s
end

-- Fast (uses table.concat)
local function fastConcat()
    local t = {}
    for i = 1, 1000 do
        t[i] = tostring(i)
    end
    return table.concat(t)
end

-- 4. Avoid table.insert in loops when possible
print("\n=== Array Building ===")

-- Slower
local function withInsert()
    local t = {}
    for i = 1, 10000 do
        table.insert(t, i)
    end
    return t
end

-- Faster
local function withDirectAssignment()
    local t = {}
    for i = 1, 10000 do
        t[i] = i
    end
    return t
end

-- 5. Cache table lookups
print("\n=== Cache Lookups ===")

-- Slow
local function slowLookup(data)
    for i = 1, #data do
        print(data.config.settings.timeout)  -- Lookup chain every time
    end
end

-- Fast
local function fastLookup(data)
    local timeout = data.config.settings.timeout  -- Cache
    for i = 1, #data do
        print(timeout)
    end
end

-- 6. Use ipairs for sequential arrays
print("\n=== Array Iteration ===")

local array = {10, 20, 30, 40, 50}

-- Slower (pairs checks all keys)
for k, v in pairs(array) do
    -- process
end

-- Faster (ipairs optimized for arrays)
for i, v in ipairs(array) do
    -- process
end

-- Fastest (numeric for)
for i = 1, #array do
    local v = array[i]
    -- process
end

-- 7. Avoid creating functions in loops
print("\n=== Function Creation ===")

-- Slow (creates new function each iteration)
local function slowFunctionCreation()
    local callbacks = {}
    for i = 1, 1000 do
        callbacks[i] = function() return i end
    end
    return callbacks
end

-- Better (reuse function)
local function betterFunctionCreation()
    local function makeCallback(value)
        return function() return value end
    end
    
    local callbacks = {}
    for i = 1, 1000 do
        callbacks[i] = makeCallback(i)
    end
    return callbacks
end

-- 8. Use local functions
print("\n=== Local Functions ===")

-- Slower (global function)
function globalFunc(x)
    return x * 2
end

-- Faster (local function)
local function localFunc(x)
    return x * 2
end

-- 9. Minimize table creations
print("\n=== Reuse Tables ===")

-- Slow (creates new table each time)
local function slowTableReuse()
    for i = 1, 1000 do
        local temp = {x = i, y = i * 2}
        -- process temp
    end
end

-- Faster (reuse table)
local function fastTableReuse()
    local temp = {}
    for i = 1, 1000 do
        temp.x = i
        temp.y = i * 2
        -- process temp
    end
end

-- 10. Use math functions efficiently
print("\n=== Math Operations ===")

-- Slower
local function slowMath(x)
    return x ^ 2  -- Power operator
end

-- Faster
local function fastMath(x)
    return x * x  -- Direct multiplication
end

-- 11. Avoid unnecessary type conversions
print("\n=== Type Conversions ===")

-- Slower
local function slowConversion(n)
    return tostring(n) .. ""
end

-- Faster
local function fastConversion(n)
    return tostring(n)
end

-- 12. Use weak tables for caches
print("\n=== Weak Tables ===")

local cache = {}
setmetatable(cache, {__mode = "v"})  -- Values are weak

local function getCachedValue(key)
    if not cache[key] then
        cache[key] = expensiveComputation(key)
    end
    return cache[key]
end

function expensiveComputation(key)
    return key * 2  -- Simulated expensive operation
end

-- 13. Batch operations
print("\n=== Batch Operations ===")

-- Slower (many small operations)
local function manySmallOps()
    local sum = 0
    for i = 1, 1000 do
        sum = sum + i
    end
    return sum
end

-- Same speed, but principle applies to I/O
-- Batch file writes, database operations, etc.

-- 14. Profile before optimizing
print("\n=== Profiling ===")

local function profile(func, name)
    local start = os.clock()
    func()
    local elapsed = os.clock() - start
    print(string.format("%s: %.6f seconds", name, elapsed))
end

profile(slowConcat, "Slow concat")
profile(fastConcat, "Fast concat")

-- 15. Memory management
print("\n=== Memory Management ===")

-- Force garbage collection when needed
collectgarbage("collect")

-- Check memory usage
local memBefore = collectgarbage("count")
-- ... do work ...
local memAfter = collectgarbage("count")
print(string.format("Memory used: %.2f KB", memAfter - memBefore))

-- 16. Avoid global variables
print("\n=== Avoid Globals ===")

-- Slow
_G.counter = 0
function incrementGlobal()
    _G.counter = _G.counter + 1
end

-- Fast
local counter = 0
local function incrementLocal()
    counter = counter + 1
end
