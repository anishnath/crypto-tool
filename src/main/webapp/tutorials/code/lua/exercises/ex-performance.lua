-- Exercise: Performance & Optimization
-- TODO: Complete the following exercises

-- 1. Optimize this string concatenation
local function slowConcat()
    local s = ""
    for i = 1, 1000 do
        s = s .. tostring(i)
    end
    return s
end

-- Optimized version:
-- local function fastConcat()
--     -- your code here
--     -- use table.concat
-- end

-- 2. Optimize this table lookup
local config = {
    settings = {
        timeout = 30
    }
}

local function slowLookup()
    for i = 1, 10000 do
        local timeout = config.settings.timeout
        -- use timeout
    end
end

-- Optimized version:
-- local function fastLookup()
--     -- your code here
--     -- cache the lookup
-- end

-- 3. Optimize this global access
_G.counter = 0

function incrementGlobal()
    for i = 1, 10000 do
        _G.counter = _G.counter + 1
    end
end

-- Optimized version:
-- local function incrementLocal()
--     -- your code here
--     -- use local variable
-- end

-- 4. Optimize this table creation
local function manyTables()
    for i = 1, 10000 do
        local temp = {x = i, y = i * 2}
        -- use temp
    end
end

-- Optimized version:
-- local function reuseTable()
--     -- your code here
--     -- reuse single table
-- end

-- 5. Optimize this math operation
local function slowSquare(x)
    return x ^ 2
end

-- Optimized version:
-- local function fastSquare(x)
--     -- your code here
--     -- use multiplication
-- end

-- 6. Create a memoized fibonacci function
local function fibonacci(n)
    if n <= 1 then return n end
    return fibonacci(n - 1) + fibonacci(n - 2)
end

-- Memoized version:
-- local cache = {}
-- local function fibonacciMemo(n)
--     -- your code here
--     -- use cache to store results
-- end

-- 7. Optimize this loop
local data = {}
for i = 1, 10000 do
    data[i] = i
end

local function slowLoop()
    for i = 1, #data do  -- #data called each time
        local v = data[i]
    end
end

-- Optimized version:
-- local function fastLoop()
--     -- your code here
--     -- cache the length
-- end

-- 8. Create a string buffer
-- TODO: Implement a string buffer that efficiently builds strings
local function createStringBuffer()
    -- your code here
    -- return table with append() and toString() methods
end

-- local buf = createStringBuffer()
-- buf.append("Hello")
-- buf.append(" ")
-- buf.append("World")
-- print(buf.toString())

-- 9. Profile a function
-- TODO: Write a profiling function
local function profile(func, name)
    -- your code here
    -- measure execution time using os.clock()
end

-- profile(function()
--     local sum = 0
--     for i = 1, 1000000 do
--         sum = sum + i
--     end
-- end, "Sum")

-- 10. Optimize this array iteration
local array = {}
for i = 1, 10000 do
    array[i] = i
end

local function slowIteration()
    for k, v in pairs(array) do
        -- process
    end
end

-- Optimized version:
-- local function fastIteration()
--     -- your code here
--     -- use numeric for loop or ipairs
-- end
