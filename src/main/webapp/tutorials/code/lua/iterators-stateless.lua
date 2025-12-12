-- Stateless Iterator Examples in Lua

-- Custom stateless iterator for a range
local function range_iter(max, current)
    current = current + 1
    if current <= max then
        return current
    end
end

function range(max)
    return range_iter, max, 0
end

print("=== Custom range iterator ===")
for i in range(5) do
    print(i)
end

-- Stateless iterator for even numbers
local function even_iter(max, current)
    current = current + 2
    if current <= max then
        return current
    end
end

function evens(max)
    return even_iter, max, 0
end

print("\n=== Even numbers ===")
for num in evens(10) do
    print(num)
end

-- Stateless iterator for array with filter
local function filter_iter(t, i)
    i = i + 1
    local v = t[i]
    if v then
        if v > 10 then
            return i, v
        else
            return filter_iter(t, i)
        end
    end
end

function filter_greater_than_10(t)
    return filter_iter, t, 0
end

print("\n=== Filtered values > 10 ===")
local numbers = {5, 15, 8, 20, 12, 3}
for i, v in filter_greater_than_10(numbers) do
    print(i, v)
end
