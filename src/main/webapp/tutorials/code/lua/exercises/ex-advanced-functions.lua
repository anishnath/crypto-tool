-- Exercise: Advanced Functions
-- TODO: Complete the following exercises

-- 1. Create a map function that transforms an array
local function map(array, func)
    -- your code here
end

local numbers = {1, 2, 3, 4, 5}
-- local doubled = map(numbers, function(x) return x * 2 end)
-- print("Doubled:", table.concat(doubled, ", "))

-- 2. Create a filter function that selects elements
local function filter(array, predicate)
    -- your code here
end

-- local evens = filter(numbers, function(x) return x % 2 == 0 end)
-- print("Evens:", table.concat(evens, ", "))

-- 3. Create a reduce function that accumulates values
local function reduce(array, func, initial)
    -- your code here
end

-- local sum = reduce(numbers, function(acc, x) return acc + x end, 0)
-- print("Sum:", sum)

-- 4. Create a function that returns the sum of any number of arguments
local function sum(...)
    -- your code here
end

-- print("Sum:", sum(1, 2, 3, 4, 5))

-- 5. Create a function composition helper
local function compose(f, g)
    -- your code here
    -- return a function that applies g then f
end

local addOne = function(x) return x + 1 end
local double = function(x) return x * 2 end
-- local addThenDouble = compose(double, addOne)
-- print("(5+1)*2 =", addThenDouble(5))

-- 6. Create a memoization function
local function memoize(func)
    -- your code here
    -- cache results and return cached value if available
end

local function fibonacci(n)
    if n <= 1 then return n end
    return fibonacci(n - 1) + fibonacci(n - 2)
end

-- local fastFib = memoize(fibonacci)
-- print("Fib(10):", fastFib(10))

-- 7. Create a debounce function (advanced)
-- Returns a function that only executes after being called
-- and then not called again for 'delay' calls
local function debounce(func, delay)
    -- your code here
    -- hint: use a counter
end

-- local debouncedPrint = debounce(print, 3)
-- debouncedPrint("Call 1")  -- Won't execute
-- debouncedPrint("Call 2")  -- Won't execute
-- debouncedPrint("Call 3")  -- Executes!
