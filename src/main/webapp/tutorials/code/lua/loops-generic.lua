-- Generic For Loops with pairs and ipairs

-- Arrays in Lua (1-based indexing!)
local fruits = {"apple", "banana", "cherry", "date"}

-- ipairs for arrays (integer pairs)
print("=== ipairs (for arrays) ===")
for index, value in ipairs(fruits) do
    print(index, value)
end

-- pairs for tables (all key-value pairs)
print("\n=== pairs (for tables) ===")
local person = {
    name = "Alice",
    age = 25,
    city = "New York"
}

for key, value in pairs(person) do
    print(key, "=", value)
end

-- pairs vs ipairs difference
print("\n=== pairs vs ipairs ===")
local mixed = {
    [1] = "first",
    [2] = "second",
    [5] = "fifth",  -- Gap in indices!
    name = "test"
}

print("With ipairs (stops at first nil):")
for i, v in ipairs(mixed) do
    print(i, v)
end

print("\nWith pairs (gets all):")
for k, v in pairs(mixed) do
    print(k, v)
end

-- Iterating over array of tables
print("\n=== Array of Tables ===")
local users = {
    {name = "Alice", age = 25},
    {name = "Bob", age = 30},
    {name = "Charlie", age = 35}
}

for i, user in ipairs(users) do
    print(i .. ".", user.name, "-", user.age, "years old")
end

-- Nested table iteration
print("\n=== Nested Tables ===")
local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}

for i, row in ipairs(matrix) do
    for j, value in ipairs(row) do
        io.write(value .. " ")
    end
    print()
end

-- Counting and filtering
print("\n=== Filtering ===")
local numbers = {10, 25, 30, 15, 40, 5}
local count = 0

for i, num in ipairs(numbers) do
    if num > 20 then
        print("Found:", num, "at index", i)
        count = count + 1
    end
end

print("Total found:", count)

-- Building new table from iteration
print("\n=== Transform ===")
local original = {1, 2, 3, 4, 5}
local doubled = {}

for i, value in ipairs(original) do
    doubled[i] = value * 2
end

print("Doubled:", table.concat(doubled, ", "))
