-- Table Manipulation Techniques

-- Deep copy (recursive)
local function deepCopy(original)
    if type(original) ~= "table" then
        return original
    end
    
    local copy = {}
    for k, v in pairs(original) do
        copy[k] = deepCopy(v)  -- Recursive copy
    end
    return copy
end

local original = {a = 1, b = {c = 2, d = 3}}
local copy = deepCopy(original)
copy.b.c = 999

print("=== Deep Copy ===")
print("Original b.c:", original.b.c)  -- 2 (unchanged)
print("Copy b.c:", copy.b.c)          -- 999

-- Merge tables
local function merge(t1, t2)
    local result = {}
    for k, v in pairs(t1) do
        result[k] = v
    end
    for k, v in pairs(t2) do
        result[k] = v  -- Overwrites if exists
    end
    return result
end

print("\n=== Merge Tables ===")
local defaults = {theme = "dark", lang = "en", size = 12}
local settings = {theme = "light", size = 14}
local config = merge(defaults, settings)

for k, v in pairs(config) do
    print(k, "=", v)
end

-- Filter table
local function filter(tbl, predicate)
    local result = {}
    for i, v in ipairs(tbl) do
        if predicate(v) then
            table.insert(result, v)
        end
    end
    return result
end

print("\n=== Filter ===")
local numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local evens = filter(numbers, function(x) return x % 2 == 0 end)
print("Evens:", table.concat(evens, ", "))

-- Map table
local function map(tbl, func)
    local result = {}
    for i, v in ipairs(tbl) do
        result[i] = func(v)
    end
    return result
end

print("\n=== Map ===")
local squared = map(numbers, function(x) return x * x end)
print("Squared:", table.concat(squared, ", "))

-- Reduce table
local function reduce(tbl, func, initial)
    local acc = initial
    for i, v in ipairs(tbl) do
        acc = func(acc, v)
    end
    return acc
end

print("\n=== Reduce ===")
local sum = reduce(numbers, function(acc, x) return acc + x end, 0)
print("Sum:", sum)

-- Find in table
local function find(tbl, predicate)
    for i, v in ipairs(tbl) do
        if predicate(v) then
            return v, i
        end
    end
    return nil
end

print("\n=== Find ===")
local found, index = find(numbers, function(x) return x > 5 end)
print("First > 5:", found, "at index", index)

-- Count occurrences
local function count(tbl, value)
    local c = 0
    for i, v in ipairs(tbl) do
        if v == value then
            c = c + 1
        end
    end
    return c
end

print("\n=== Count ===")
local items = {1, 2, 3, 2, 4, 2, 5}
print("Count of 2:", count(items, 2))

-- Remove duplicates
local function unique(tbl)
    local seen = {}
    local result = {}
    for i, v in ipairs(tbl) do
        if not seen[v] then
            seen[v] = true
            table.insert(result, v)
        end
    end
    return result
end

print("\n=== Unique ===")
local duplicates = {1, 2, 3, 2, 4, 3, 5, 1}
local uniq = unique(duplicates)
print("Unique:", table.concat(uniq, ", "))

-- Flatten nested table
local function flatten(tbl)
    local result = {}
    for i, v in ipairs(tbl) do
        if type(v) == "table" then
            for j, inner in ipairs(flatten(v)) do
                table.insert(result, inner)
            end
        else
            table.insert(result, v)
        end
    end
    return result
end

print("\n=== Flatten ===")
local nested = {1, {2, 3}, {4, {5, 6}}, 7}
local flat = flatten(nested)
print("Flattened:", table.concat(flat, ", "))

-- Group by
local function groupBy(tbl, keyFunc)
    local groups = {}
    for i, v in ipairs(tbl) do
        local key = keyFunc(v)
        if not groups[key] then
            groups[key] = {}
        end
        table.insert(groups[key], v)
    end
    return groups
end

print("\n=== Group By ===")
local words = {"apple", "ant", "banana", "bear", "cat", "cherry"}
local grouped = groupBy(words, function(w) return string.sub(w, 1, 1) end)

for letter, group in pairs(grouped) do
    print(letter .. ":", table.concat(group, ", "))
end

-- Chunk array
local function chunk(tbl, size)
    local chunks = {}
    for i = 1, #tbl, size do
        local chunk = {}
        for j = i, math.min(i + size - 1, #tbl) do
            table.insert(chunk, tbl[j])
        end
        table.insert(chunks, chunk)
    end
    return chunks
end

print("\n=== Chunk ===")
local data = {1, 2, 3, 4, 5, 6, 7, 8, 9}
local chunks = chunk(data, 3)
for i, c in ipairs(chunks) do
    print("Chunk " .. i .. ":", table.concat(c, ", "))
end
