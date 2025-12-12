-- Iterator Exercises

-- Exercise 1: Create a custom iterator that returns only odd numbers from a table
function odd_numbers(t)
    -- TODO: Implement iterator for odd numbers
    local i = 0
    return function()
        i = i + 1
        while t[i] do
            if t[i] % 2 ~= 0 then
                return i, t[i]
            end
            i = i + 1
        end
    end
end

-- Test Exercise 1
print("=== Exercise 1: Odd numbers ===")
local nums = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
for i, v in odd_numbers(nums) do
    print(i, v)
end

-- Exercise 2: Create an iterator that skips nil values
function skip_nil(t)
    -- TODO: Implement iterator that skips nil values
    local i = 0
    return function()
        i = i + 1
        while i <= #t + 10 do  -- Check beyond array length
            if t[i] ~= nil then
                return i, t[i]
            end
            i = i + 1
        end
    end
end

-- Test Exercise 2
print("\n=== Exercise 2: Skip nil values ===")
local sparse = {10, nil, 30, nil, 50}
for i, v in skip_nil(sparse) do
    print(i, v)
end

-- Exercise 3: Create a pairwise iterator (returns consecutive pairs)
function pairwise(t)
    -- TODO: Implement pairwise iterator
    local i = 0
    return function()
        i = i + 1
        if t[i] and t[i + 1] then
            return i, t[i], t[i + 1]
        end
    end
end

-- Test Exercise 3
print("\n=== Exercise 3: Pairwise ===")
local items = {1, 2, 3, 4, 5}
for i, a, b in pairwise(items) do
    print(i, a, b)
end

-- Exercise 4: Create a cycle iterator (repeats the sequence)
function cycle(t, times)
    -- TODO: Implement cycle iterator
    local i = 0
    local count = 0
    return function()
        i = i + 1
        if i > #t then
            i = 1
            count = count + 1
        end
        if count < times then
            return i, t[i]
        end
    end
end

-- Test Exercise 4
print("\n=== Exercise 4: Cycle 3 times ===")
local pattern = {"A", "B", "C"}
for i, v in cycle(pattern, 3) do
    print(i, v)
end

-- Exercise 5: Create a flatten iterator for nested tables
function flatten(t)
    -- TODO: Implement flatten iterator
    local stack = {{table = t, index = 1}}
    
    return function()
        while #stack > 0 do
            local current = stack[#stack]
            local value = current.table[current.index]
            
            if value == nil then
                table.remove(stack)
            elseif type(value) == "table" then
                current.index = current.index + 1
                table.insert(stack, {table = value, index = 1})
            else
                current.index = current.index + 1
                return value
            end
        end
    end
end

-- Test Exercise 5
print("\n=== Exercise 5: Flatten nested tables ===")
local nested = {1, {2, 3}, {4, {5, 6}}, 7}
for v in flatten(nested) do
    print(v)
end
