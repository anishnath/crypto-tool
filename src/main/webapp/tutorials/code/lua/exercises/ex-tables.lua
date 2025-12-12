-- Table Exercises

-- Exercise 1: Create and access tables
print("=== Exercise 1: Table Creation ===")
-- TODO: Create a table with your information
local person = {
    name = "John Doe",
    age = 25,
    city = "New York"
}

print("Name:", person.name)
print("Age:", person.age)
print("City:", person.city)

-- Exercise 2: Array operations
print("\n=== Exercise 2: Arrays ===")
local colors = {"red", "green", "blue"}
-- TODO: Add "yellow" to the array
colors[4] = "yellow"
-- TODO: Print the length
print("Number of colors:", #colors)
-- TODO: Print all colors
for i, color in ipairs(colors) do
    print(i, color)
end

-- Exercise 3: Nested tables
print("\n=== Exercise 3: Nested Tables ===")
local company = {
    name = "TechCorp",
    employees = {
        {name = "Alice", role = "Developer"},
        {name = "Bob", role = "Designer"},
        {name = "Charlie", role = "Manager"}
    }
}

-- TODO: Print all employee names
for i, emp in ipairs(company.employees) do
    print(string.format("%d. %s - %s", i, emp.name, emp.role))
end

-- Exercise 4: Table as dictionary
print("\n=== Exercise 4: Dictionary ===")
local inventory = {
    apples = 10,
    bananas = 5,
    oranges = 8
}

-- TODO: Add grapes with quantity 12
inventory.grapes = 12

-- TODO: Update apples to 15
inventory.apples = 15

-- TODO: Print all items
for item, quantity in pairs(inventory) do
    print(item, quantity)
end

-- Exercise 5: Mixed tables
print("\n=== Exercise 5: Mixed Tables ===")
local mixed = {
    10, 20, 30,  -- array part
    name = "Mixed Table",  -- hash part
    active = true
}

-- TODO: Access both parts
print("First element:", mixed[1])
print("Name:", mixed.name)
print("Active:", mixed.active)

-- Exercise 6: Table manipulation
print("\n=== Exercise 6: Table Manipulation ===")
local numbers = {5, 10, 15, 20, 25}

-- TODO: Double all numbers
for i = 1, #numbers do
    numbers[i] = numbers[i] * 2
end

print("Doubled:", table.concat(numbers, ", "))

-- Exercise 7: Table copying
print("\n=== Exercise 7: Shallow Copy ===")
local original = {a = 1, b = 2, c = 3}
local copy = {}

-- TODO: Copy all key-value pairs
for k, v in pairs(original) do
    copy[k] = v
end

copy.d = 4  -- Add to copy
print("Original has 'd':", original.d)  -- nil
print("Copy has 'd':", copy.d)  -- 4

-- Exercise 8: Table as set
print("\n=== Exercise 8: Set Operations ===")
local set = {}

-- TODO: Add elements to set
local items = {"apple", "banana", "apple", "cherry", "banana"}
for _, item in ipairs(items) do
    set[item] = true
end

-- TODO: Print unique items
print("Unique items:")
for item in pairs(set) do
    print("-", item)
end

-- Exercise 9: Count elements
print("\n=== Exercise 9: Counting ===")
local data = {a = 1, b = 2, c = 3, d = 4, e = 5}

-- TODO: Count how many key-value pairs
local count = 0
for _ in pairs(data) do
    count = count + 1
end

print("Number of pairs:", count)

-- Exercise 10: Table filtering
print("\n=== Exercise 10: Filtering ===")
local all_numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local even_numbers = {}

-- TODO: Filter only even numbers
for _, num in ipairs(all_numbers) do
    if num % 2 == 0 then
        table.insert(even_numbers, num)
    end
end

print("Even numbers:", table.concat(even_numbers, ", "))

print("\n=== All Exercises Complete ===")
