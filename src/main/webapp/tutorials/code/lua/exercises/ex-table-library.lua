-- Table Library Exercises

-- Exercise 1: Use table.insert to build an array
print("=== Exercise 1: Building Arrays ===")
local fruits = {}
-- TODO: Use table.insert to add: "apple", "banana", "cherry"
table.insert(fruits, "apple")
table.insert(fruits, "banana")
table.insert(fruits, "cherry")

print("Fruits:", table.concat(fruits, ", "))

-- Exercise 2: Use table.remove to remove elements
print("\n=== Exercise 2: Removing Elements ===")
local numbers = {10, 20, 30, 40, 50}
-- TODO: Remove the element at index 3
table.remove(numbers, 3)
print("After removal:", table.concat(numbers, ", "))

-- Exercise 3: Sort a table
print("\n=== Exercise 3: Sorting ===")
local scores = {85, 92, 78, 95, 88}
-- TODO: Sort the scores in descending order
table.sort(scores, function(a, b) return a > b end)
print("Sorted scores:", table.concat(scores, ", "))

-- Exercise 4: Concatenate with custom separator
print("\n=== Exercise 4: Concatenation ===")
local words = {"Lua", "is", "awesome"}
-- TODO: Join with " - " separator
local result = table.concat(words, " - ")
print("Result:", result)

-- Exercise 5: Pack and unpack
print("\n=== Exercise 5: Pack and Unpack ===")
local function sum(...)
    local args = table.pack(...)
    local total = 0
    for i = 1, args.n do
        total = total + args[i]
    end
    return total
end

print("Sum of 1,2,3,4,5:", sum(1, 2, 3, 4, 5))

-- Exercise 6: Custom sorting with objects
print("\n=== Exercise 6: Sorting Objects ===")
local students = {
    {name = "Alice", grade = 85},
    {name = "Bob", grade = 92},
    {name = "Charlie", grade = 78}
}

-- TODO: Sort by grade (highest first)
table.sort(students, function(a, b)
    return a.grade > b.grade
end)

for i, student in ipairs(students) do
    print(string.format("%d. %s: %d", i, student.name, student.grade))
end

-- Exercise 7: Move elements
print("\n=== Exercise 7: Moving Elements ===")
local source = {1, 2, 3, 4, 5}
local dest = {}

-- TODO: Use table.move to copy elements 2-4 to dest
table.move(source, 2, 4, 1, dest)
print("Source:", table.concat(source, ", "))
print("Dest:", table.concat(dest, ", "))

print("\n=== Exercises Complete ===")
