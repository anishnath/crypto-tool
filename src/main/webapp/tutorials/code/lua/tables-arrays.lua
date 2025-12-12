-- Arrays in Lua (Sequential Tables)

-- Creating arrays - 1-based indexing!
local numbers = {10, 20, 30, 40, 50}

print("=== Basic Array ===")
print("First element:", numbers[1])   -- 10
print("Last element:", numbers[5])    -- 50
print("Length:", #numbers)            -- 5

-- Iterating with ipairs (for arrays)
print("\n=== Iteration with ipairs ===")
for index, value in ipairs(numbers) do
    print(index, value)
end

-- Iterating with numeric for
print("\n=== Numeric for loop ===")
for i = 1, #numbers do
    print(i, numbers[i])
end

-- Multi-dimensional arrays
local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}

print("\n=== 2D Array ===")
for i = 1, #matrix do
    for j = 1, #matrix[i] do
        io.write(matrix[i][j] .. " ")
    end
    print()
end

-- Array of tables
local students = {
    {name = "Alice", grade = 95},
    {name = "Bob", grade = 87},
    {name = "Charlie", grade = 92}
}

print("\n=== Array of Tables ===")
for i, student in ipairs(students) do
    print(i .. ".", student.name, "-", student.grade)
end

-- Sparse arrays (gaps in indices)
local sparse = {}
sparse[1] = "first"
sparse[3] = "third"
sparse[5] = "fifth"

print("\n=== Sparse Array ===")
print("Length:", #sparse)  -- Undefined! Could be 1, 3, or 5

-- Use pairs for sparse arrays
for index, value in pairs(sparse) do
    print(index, value)
end

-- Array initialization patterns
local zeros = {}
for i = 1, 5 do
    zeros[i] = 0
end
print("\n=== Initialized Array ===")
print("Zeros:", table.concat(zeros, ", "))

-- Array with mixed types
local mixed = {42, "hello", true, {x = 10}, function() return "hi" end}

print("\n=== Mixed Types ===")
print("Number:", mixed[1])
print("String:", mixed[2])
print("Boolean:", mixed[3])
print("Table:", mixed[4].x)
print("Function:", mixed[5]())

-- Common array operations
local arr = {1, 2, 3, 4, 5}

-- Sum
local sum = 0
for i, v in ipairs(arr) do
    sum = sum + v
end
print("\n=== Operations ===")
print("Sum:", sum)

-- Find maximum
local max = arr[1]
for i = 2, #arr do
    if arr[i] > max then
        max = arr[i]
    end
end
print("Max:", max)

-- Reverse
local reversed = {}
for i = #arr, 1, -1 do
    table.insert(reversed, arr[i])
end
print("Reversed:", table.concat(reversed, ", "))
