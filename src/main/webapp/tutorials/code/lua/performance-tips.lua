-- Performance Tips and Best Practices

-- Collection of performance optimization tips for Lua

print("=== Use Local Variables ===")

-- Slow: Global variable access
_G.counter = 0
function incrementGlobal()
    for i = 1, 100000 do
        _G.counter = _G.counter + 1
    end
end

-- Fast: Local variable access
local function incrementLocal()
    local counter = 0
    for i = 1, 100000 do
        counter = counter + 1
    end
    return counter
end

local start = os.clock()
incrementGlobal()
print("Global access:", os.clock() - start)

start = os.clock()
incrementLocal()
print("Local access:", os.clock() - start)

print("\n=== Cache Table Lookups ===")

local math = math  -- Cache global

-- Slow: Repeated global lookup
local function slowMath()
    for i = 1, 100000 do
        math.sqrt(i)
    end
end

-- Fast: Cache function
local function fastMath()
    local sqrt = math.sqrt
    for i = 1, 100000 do
        sqrt(i)
    end
end

start = os.clock()
slowMath()
print("Repeated lookup:", os.clock() - start)

start = os.clock()
fastMath()
print("Cached lookup:", os.clock() - start)

print("\n=== Avoid Function Calls in Loops ===")

local data = {}
for i = 1, 10000 do
    data[i] = i
end

-- Slow: Function call each iteration
local function slowLoop()
    for i = 1, #data do  -- #data called each time
        local v = data[i]
    end
end

-- Fast: Cache length
local function fastLoop()
    local len = #data
    for i = 1, len do
        local v = data[i]
    end
end

start = os.clock()
slowLoop()
print("Function in loop:", os.clock() - start)

start = os.clock()
fastLoop()
print("Cached length:", os.clock() - start)

print("\n=== Use Appropriate Data Structures ===")

-- Arrays for sequential data
local array = {1, 2, 3, 4, 5}

-- Hash tables for key-value pairs
local hash = {name = "Alice", age = 25}

-- Sets using tables
local set = {apple = true, banana = true, cherry = true}

print("Is apple in set:", set["apple"])

print("\n=== Minimize Table Creations ===")

-- Slow: Create table each iteration
local function manyTables()
    for i = 1, 10000 do
        local temp = {x = i, y = i * 2}
    end
end

-- Fast: Reuse table
local function reuseTable()
    local temp = {}
    for i = 1, 10000 do
        temp.x = i
        temp.y = i * 2
    end
end

start = os.clock()
manyTables()
print("Many tables:", os.clock() - start)

start = os.clock()
reuseTable()
print("Reuse table:", os.clock() - start)

print("\n=== Use Numeric For Loops ===")

-- Fastest loop type
for i = 1, 10 do
    -- Fast
end

-- Slower: Generic for with ipairs
for i, v in ipairs({1,2,3,4,5}) do
    -- Slower
end

print("\n=== Avoid Unnecessary Type Conversions ===")

-- Keep numbers as numbers
local n = 42
-- Don't: tostring(n) unless needed

-- Keep strings as strings
local s = "42"
-- Don't: tonumber(s) unless needed

print("\n=== Use Math Operators Efficiently ===")

-- Slow: Power operator for squaring
local function slowSquare(x)
    return x ^ 2
end

-- Fast: Multiplication
local function fastSquare(x)
    return x * x
end

start = os.clock()
for i = 1, 100000 do
    slowSquare(i)
end
print("Power operator:", os.clock() - start)

start = os.clock()
for i = 1, 100000 do
    fastSquare(i)
end
print("Multiplication:", os.clock() - start)

print("\n=== Memory Management ===")

-- Check memory usage
local memBefore = collectgarbage("count")
print("Memory before:", memBefore, "KB")

-- Create some data
local bigTable = {}
for i = 1, 100000 do
    bigTable[i] = i
end

local memAfter = collectgarbage("count")
print("Memory after:", memAfter, "KB")
print("Used:", memAfter - memBefore, "KB")

-- Force garbage collection
collectgarbage("collect")
print("After GC:", collectgarbage("count"), "KB")

print("\n=== Profiling ===")

local function profile(func, name)
    local start = os.clock()
    func()
    local elapsed = os.clock() - start
    print(string.format("%s: %.6f seconds", name, elapsed))
end

profile(function()
    local sum = 0
    for i = 1, 1000000 do
        sum = sum + i
    end
end, "Sum calculation")

print("\n=== Lazy Evaluation ===")

-- Don't compute unless needed
local function expensiveOperation()
    print("Computing...")
    return 42
end

local function lazyExample(condition)
    -- Only compute if needed
    if condition then
        return expensiveOperation()
    end
    return 0
end

print("Result:", lazyExample(false))  -- Doesn't compute

print("\n=== Memoization ===")

local cache = {}

local function fibonacci(n)
    if n <= 1 then return n end
    
    if not cache[n] then
        cache[n] = fibonacci(n - 1) + fibonacci(n - 2)
    end
    
    return cache[n]
end

start = os.clock()
print("Fib(30):", fibonacci(30))
print("Time:", os.clock() - start)

print("\n=== Best Practices Summary ===")
print("1. Use local variables")
print("2. Cache table lookups")
print("3. Use table.concat for strings")
print("4. Minimize table creations")
print("5. Use numeric for loops")
print("6. Cache function references")
print("7. Avoid unnecessary conversions")
print("8. Use appropriate data structures")
print("9. Profile before optimizing")
print("10. Use memoization for expensive computations")

print("\n=== Premature Optimization Warning ===")
print("Remember: Profile first, optimize later!")
print("Readable code > Fast code (until proven slow)")
