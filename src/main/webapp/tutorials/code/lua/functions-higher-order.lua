-- Higher-Order Functions in Lua

-- Function that takes a function as parameter
local function applyTwice(func, value)
    return func(func(value))
end

local function double(x)
    return x * 2
end

print("Apply twice:", applyTwice(double, 5))  -- 20

-- Map function (transform array)
local function map(array, func)
    local result = {}
    for i, v in ipairs(array) do
        result[i] = func(v)
    end
    return result
end

local numbers = {1, 2, 3, 4, 5}
local squared = map(numbers, function(x) return x * x end)
print("Squared:", table.concat(squared, ", "))

local doubled = map(numbers, function(x) return x * 2 end)
print("Doubled:", table.concat(doubled, ", "))

-- Filter function (select elements)
local function filter(array, predicate)
    local result = {}
    for i, v in ipairs(array) do
        if predicate(v) then
            table.insert(result, v)
        end
    end
    return result
end

local evens = filter(numbers, function(x) return x % 2 == 0 end)
print("Evens:", table.concat(evens, ", "))

local greaterThan3 = filter(numbers, function(x) return x > 3 end)
print("Greater than 3:", table.concat(greaterThan3, ", "))

-- Reduce function (fold/accumulate)
local function reduce(array, func, initial)
    local accumulator = initial
    for i, v in ipairs(array) do
        accumulator = func(accumulator, v)
    end
    return accumulator
end

local sum = reduce(numbers, function(acc, x) return acc + x end, 0)
print("Sum:", sum)

local product = reduce(numbers, function(acc, x) return acc * x end, 1)
print("Product:", product)

-- ForEach function
local function forEach(array, func)
    for i, v in ipairs(array) do
        func(v, i)
    end
end

print("\nForEach:")
forEach(numbers, function(value, index)
    print(index, "->", value)
end)

-- Function composition
local function compose(f, g)
    return function(x)
        return f(g(x))
    end
end

local addOne = function(x) return x + 1 end
local multiplyByTwo = function(x) return x * 2 end

local addThenMultiply = compose(multiplyByTwo, addOne)
print("\nCompose (5+1)*2:", addThenMultiply(5))

-- Partial application
local function partial(func, ...)
    local args1 = {...}
    return function(...)
        local args2 = {...}
        local allArgs = {}
        for i, v in ipairs(args1) do
            table.insert(allArgs, v)
        end
        for i, v in ipairs(args2) do
            table.insert(allArgs, v)
        end
        return func(table.unpack(allArgs))
    end
end

local function add3(a, b, c)
    return a + b + c
end

local add10AndMore = partial(add3, 10)
print("\nPartial application:", add10AndMore(5, 3))

-- Sort with custom comparator
local people = {
    {name = "Alice", age = 25},
    {name = "Bob", age = 30},
    {name = "Charlie", age = 20}
}

table.sort(people, function(a, b)
    return a.age < b.age
end)

print("\nSorted by age:")
forEach(people, function(person)
    print(person.name, person.age)
end)

-- Find function
local function find(array, predicate)
    for i, v in ipairs(array) do
        if predicate(v) then
            return v, i
        end
    end
    return nil
end

local found, index = find(numbers, function(x) return x > 3 end)
print("\nFirst > 3:", found, "at index", index)

-- Every and Some
local function every(array, predicate)
    for i, v in ipairs(array) do
        if not predicate(v) then
            return false
        end
    end
    return true
end

local function some(array, predicate)
    for i, v in ipairs(array) do
        if predicate(v) then
            return true
        end
    end
    return false
end

print("\nAll positive?", every(numbers, function(x) return x > 0 end))
print("Any > 4?", some(numbers, function(x) return x > 4 end))
