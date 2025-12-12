-- Exercise: Coroutines
-- TODO: Complete the following exercises

-- 1. Create a simple coroutine that yields three times
local function simpleCoroutine()
    -- your code here
    -- yield "first", "second", "third"
end

-- local co = coroutine.create(simpleCoroutine)
-- print(coroutine.resume(co))
-- print(coroutine.resume(co))
-- print(coroutine.resume(co))

-- 2. Create a counter generator using coroutines
local function counter(start, stop)
    -- your code here
    -- use coroutine.wrap
    -- yield numbers from start to stop
end

-- for i in counter(1, 5) do
--     print(i)
-- end

-- 3. Create a fibonacci generator
local function fibonacci(n)
    -- your code here
    -- generate first n fibonacci numbers
end

-- for num in fibonacci(10) do
--     print(num)
-- end

-- 4. Implement a filter function using coroutines
local function filter(predicate, source)
    -- your code here
    -- yield only values that pass predicate
end

-- local function range(n)
--     return coroutine.wrap(function()
--         for i = 1, n do coroutine.yield(i) end
--     end)
-- end

-- for value in filter(function(x) return x % 2 == 0 end, range(10)) do
--     print(value)
-- end

-- 5. Create a producer-consumer pattern
local function producer(items)
    -- your code here
    -- create coroutine that yields items
end

local function consumer(prod)
    -- your code here
    -- consume all items from producer
end

-- local items = {1, 2, 3, 4, 5}
-- consumer(producer(items))

-- 6. Implement a simple task scheduler
local function createScheduler()
    -- your code here
    -- return table with add() and run() methods
end

-- local sched = createScheduler()
-- sched.add(function()
--     for i = 1, 3 do
--         print("Task 1:", i)
--         coroutine.yield()
--     end
-- end)
-- sched.run()

-- 7. Create a lazy map function
local function lazyMap(func, list)
    -- your code here
    -- use coroutine to lazily apply func to each element
end

-- local doubled = lazyMap(function(x) return x * 2 end, {1, 2, 3, 4, 5})
-- for value in doubled do
--     print(value)
-- end

-- 8. Implement a take function
local function take(n, iterator)
    -- your code here
    -- yield only first n values from iterator
end

-- local function infiniteOnes()
--     return coroutine.wrap(function()
--         while true do coroutine.yield(1) end
--     end)
-- end

-- for value in take(5, infiniteOnes()) do
--     print(value)
-- end
