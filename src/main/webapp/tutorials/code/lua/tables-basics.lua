-- Table Basics in Lua

-- Tables are Lua's only data structure!
-- They can be used as arrays, dictionaries, objects, and more

-- Empty table
local empty = {}
print("Empty table:", empty)

-- Array (sequential table) - 1-based indexing!
local fruits = {"apple", "banana", "cherry"}
print("\n=== Array ===")
print("First fruit:", fruits[1])  -- NOT fruits[0]!
print("Second fruit:", fruits[2])
print("Third fruit:", fruits[3])

-- Length operator
print("Number of fruits:", #fruits)

-- Adding to array
fruits[4] = "date"
print("After adding:", #fruits)

-- Dictionary (associative array)
local person = {
    name = "Alice",
    age = 25,
    city = "New York"
}

print("\n=== Dictionary ===")
print("Name:", person.name)
print("Age:", person["age"])  -- Both syntaxes work
print("City:", person.city)

-- Adding new key
person.email = "alice@example.com"
print("Email:", person.email)

-- Mixed table (both numeric and string keys)
local mixed = {
    "first",     -- index 1
    "second",    -- index 2
    name = "Mixed Table",
    count = 42
}

print("\n=== Mixed Table ===")
print("Index 1:", mixed[1])
print("Index 2:", mixed[2])
print("Name:", mixed.name)
print("Count:", mixed.count)

-- Nested tables
local company = {
    name = "TechCorp",
    employees = {
        {name = "Alice", role = "Developer"},
        {name = "Bob", role = "Designer"},
        {name = "Charlie", role = "Manager"}
    }
}

print("\n=== Nested Tables ===")
print("Company:", company.name)
print("First employee:", company.employees[1].name)
print("Their role:", company.employees[1].role)

-- Tables are passed by reference
local t1 = {1, 2, 3}
local t2 = t1  -- Same table, not a copy!

t2[1] = 100
print("\n=== Reference ===")
print("t1[1]:", t1[1])  -- 100 (changed!)
print("t2[1]:", t2[1])  -- 100

-- Copying a table (shallow copy)
local function copyTable(original)
    local copy = {}
    for k, v in pairs(original) do
        copy[k] = v
    end
    return copy
end

local original = {1, 2, 3}
local copy = copyTable(original)
copy[1] = 999

print("\n=== Copy ===")
print("Original[1]:", original[1])  -- 1 (unchanged)
print("Copy[1]:", copy[1])          -- 999

-- Checking if key exists
local data = {x = 10, y = 20}

if data.x then
    print("\nx exists:", data.x)
end

if data.z == nil then
    print("z does not exist")
end
