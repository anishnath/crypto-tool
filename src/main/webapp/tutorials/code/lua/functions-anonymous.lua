-- Anonymous Functions in Lua

-- Anonymous function assigned to variable
local square = function(x)
    return x * x
end

print("Square of 5:", square(5))

-- Anonymous function as argument
local numbers = {1, 2, 3, 4, 5}

local function map(array, func)
    local result = {}
    for i, v in ipairs(array) do
        result[i] = func(v)
    end
    return result
end

-- Inline anonymous function
local doubled = map(numbers, function(x)
    return x * 2
end)

print("Doubled:", table.concat(doubled, ", "))

-- Multiple anonymous functions
table.sort(numbers, function(a, b) return a > b end)
print("Sorted desc:", table.concat(numbers, ", "))

-- Anonymous function with multiple statements
local result = map({1, 2, 3}, function(x)
    local squared = x * x
    local doubled = squared * 2
    return doubled
end)

print("Squared then doubled:", table.concat(result, ", "))

-- Immediately invoked function expression (IIFE)
local value = (function(x, y)
    return x + y
end)(5, 3)

print("IIFE result:", value)

-- Anonymous function returning anonymous function
local createMultiplier = function(factor)
    return function(x)
        return x * factor
    end
end

local triple = createMultiplier(3)
print("Triple 7:", triple(7))

-- Table of anonymous functions
local operations = {
    add = function(a, b) return a + b end,
    subtract = function(a, b) return a - b end,
    multiply = function(a, b) return a * b end,
    divide = function(a, b) return a / b end
}

print("\nOperations:")
print("5 + 3 =", operations.add(5, 3))
print("5 - 3 =", operations.subtract(5, 3))
print("5 * 3 =", operations.multiply(5, 3))
print("5 / 3 =", operations.divide(5, 3))

-- Anonymous function as callback
local function processArray(array, callback)
    for i, v in ipairs(array) do
        callback(v, i)
    end
end

print("\nProcessing array:")
processArray({10, 20, 30}, function(value, index)
    print("Index " .. index .. ": " .. value)
end)

-- Anonymous function with closure
local function createCounter()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

local counter = createCounter()
print("\nCounter:")
print(counter())
print(counter())
print(counter())

-- Chaining with anonymous functions
local data = {1, 2, 3, 4, 5}

local function filter(array, pred)
    local result = {}
    for i, v in ipairs(array) do
        if pred(v) then table.insert(result, v) end
    end
    return result
end

local result = map(
    filter(data, function(x) return x % 2 == 0 end),
    function(x) return x * x end
)

print("\nChained (filter evens, then square):", table.concat(result, ", "))

-- Anonymous recursive function
local factorial
factorial = function(n)
    if n <= 1 then return 1 end
    return n * factorial(n - 1)
end

print("\nFactorial of 5:", factorial(5))

-- Anonymous function with varargs
local sum = function(...)
    local total = 0
    for i, v in ipairs({...}) do
        total = total + v
    end
    return total
end

print("Sum:", sum(1, 2, 3, 4, 5))
