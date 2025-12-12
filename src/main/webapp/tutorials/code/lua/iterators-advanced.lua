-- Advanced Iterator Techniques in Lua

-- Chaining iterators
function map(func, iter, state, var)
    return function()
        local values = {iter(state, var)}
        var = values[1]
        if var ~= nil then
            return var, func(values[2])
        end
    end
end

function filter(pred, iter, state, var)
    return function()
        while true do
            local values = {iter(state, var)}
            var = values[1]
            if var == nil or pred(values[2]) then
                return var, values[2]
            end
        end
    end
end

print("=== Map and Filter ===")
local numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

-- Filter even numbers and multiply by 2
local function is_even(n) return n % 2 == 0 end
local function double(n) return n * 2 end

for i, v in filter(is_even, ipairs(numbers)) do
    print(i, v)
end

-- Iterator composition
function compose(...)
    local funcs = {...}
    return function(...)
        local result = {...}
        for i = #funcs, 1, -1 do
            result = {funcs[i](unpack(result))}
        end
        return unpack(result)
    end
end

-- Lazy evaluation iterator
function lazy_map(func, t)
    local i = 0
    return function()
        i = i + 1
        if t[i] then
            return i, func(t[i])
        end
    end
end

print("\n=== Lazy map (square) ===")
local nums = {1, 2, 3, 4, 5}
for i, v in lazy_map(function(x) return x * x end, nums) do
    print(i, v)
end

-- Take first N elements
function take(n, iter, state, var)
    local count = 0
    return function()
        if count < n then
            count = count + 1
            local values = {iter(state, var)}
            var = values[1]
            if var ~= nil then
                return unpack(values)
            end
        end
    end
end

print("\n=== Take first 3 ===")
local all_nums = {10, 20, 30, 40, 50, 60}
for i, v in take(3, ipairs(all_nums)) do
    print(i, v)
end

-- Zip two iterators
function zip(t1, t2)
    local i = 0
    return function()
        i = i + 1
        if t1[i] and t2[i] then
            return i, t1[i], t2[i]
        end
    end
end

print("\n=== Zip two arrays ===")
local names = {"Alice", "Bob", "Charlie"}
local ages = {25, 30, 35}
for i, name, age in zip(names, ages) do
    print(i, name, age)
end
