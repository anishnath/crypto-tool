-- Sorting Tables in Lua

-- Basic numeric sort
print("=== Basic Numeric Sort ===")
local numbers = {5, 2, 8, 1, 9, 3, 7, 4, 6}
table.sort(numbers)
print("Ascending:", table.concat(numbers, ", "))

table.sort(numbers, function(a, b) return a > b end)
print("Descending:", table.concat(numbers, ", "))

-- String sort
print("\n=== String Sort ===")
local names = {"Charlie", "Alice", "Bob", "David"}
table.sort(names)
print("Alphabetical:", table.concat(names, ", "))

table.sort(names, function(a, b) return a > b end)
print("Reverse:", table.concat(names, ", "))

-- Case-insensitive sort
print("\n=== Case-Insensitive Sort ===")
local mixed = {"apple", "Banana", "cherry", "Date"}
table.sort(mixed, function(a, b)
    return string.lower(a) < string.lower(b)
end)
print("Case-insensitive:", table.concat(mixed, ", "))

-- Sort by length
print("\n=== Sort by Length ===")
local words = {"cat", "elephant", "dog", "butterfly", "ant"}
table.sort(words, function(a, b)
    return #a < #b
end)
print("By length:", table.concat(words, ", "))

-- Sort table of tables
print("\n=== Sort Table of Tables ===")
local students = {
    {name = "Alice", grade = 85},
    {name = "Bob", grade = 92},
    {name = "Charlie", grade = 78},
    {name = "David", grade = 95}
}

-- Sort by grade
table.sort(students, function(a, b)
    return a.grade > b.grade
end)

print("Sorted by grade:")
for i, student in ipairs(students) do
    print(i .. ".", student.name, "-", student.grade)
end

-- Sort by name
table.sort(students, function(a, b)
    return a.name < b.name
end)

print("\nSorted by name:")
for i, student in ipairs(students) do
    print(i .. ".", student.name, "-", student.grade)
end

-- Multi-level sort (by grade, then by name)
print("\n=== Multi-Level Sort ===")
local data = {
    {name = "Alice", grade = 85, age = 20},
    {name = "Bob", grade = 85, age = 22},
    {name = "Charlie", grade = 92, age = 21},
    {name = "David", grade = 85, age = 19}
}

table.sort(data, function(a, b)
    if a.grade == b.grade then
        return a.name < b.name  -- Secondary sort by name
    end
    return a.grade > b.grade  -- Primary sort by grade
end)

print("Sorted by grade, then name:")
for i, item in ipairs(data) do
    print(string.format("%d. %s - Grade: %d, Age: %d", 
        i, item.name, item.grade, item.age))
end

-- Stable sort (preserve original order for equal elements)
print("\n=== Custom Stable Sort ===")
local items = {
    {id = 1, value = 5},
    {id = 2, value = 3},
    {id = 3, value = 5},
    {id = 4, value = 3},
    {id = 5, value = 7}
}

-- Add original index for stability
for i, item in ipairs(items) do
    item.originalIndex = i
end

table.sort(items, function(a, b)
    if a.value == b.value then
        return a.originalIndex < b.originalIndex
    end
    return a.value < b.value
end)

print("Stable sort by value:")
for i, item in ipairs(items) do
    print(string.format("ID: %d, Value: %d", item.id, item.value))
end

-- Sort with custom comparison
print("\n=== Custom Comparison ===")
local points = {
    {x = 3, y = 4},
    {x = 1, y = 2},
    {x = 5, y = 1},
    {x = 2, y = 3}
}

-- Sort by distance from origin
table.sort(points, function(a, b)
    local distA = math.sqrt(a.x^2 + a.y^2)
    local distB = math.sqrt(b.x^2 + b.y^2)
    return distA < distB
end)

print("Sorted by distance from origin:")
for i, p in ipairs(points) do
    local dist = math.sqrt(p.x^2 + p.y^2)
    print(string.format("(%d, %d) - distance: %.2f", p.x, p.y, dist))
end
