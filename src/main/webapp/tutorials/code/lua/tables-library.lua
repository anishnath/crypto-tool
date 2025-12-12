-- Table Library Functions in Lua

local fruits = {"apple", "banana", "cherry"}

-- table.insert() - Add elements
print("=== table.insert() ===")
table.insert(fruits, "date")  -- Append to end
print("After insert:", table.concat(fruits, ", "))

table.insert(fruits, 2, "blueberry")  -- Insert at position 2
print("After insert at 2:", table.concat(fruits, ", "))

-- table.remove() - Remove elements
print("\n=== table.remove() ===")
local removed = table.remove(fruits)  -- Remove last
print("Removed:", removed)
print("After remove:", table.concat(fruits, ", "))

local removed2 = table.remove(fruits, 2)  -- Remove at position 2
print("Removed at 2:", removed2)
print("After remove at 2:", table.concat(fruits, ", "))

-- table.concat() - Join array elements
print("\n=== table.concat() ===")
local numbers = {1, 2, 3, 4, 5}
print("Concat with comma:", table.concat(numbers, ", "))
print("Concat with dash:", table.concat(numbers, " - "))
print("Concat no separator:", table.concat(numbers))

-- table.sort() - Sort array
print("\n=== table.sort() ===")
local unsorted = {5, 2, 8, 1, 9, 3}
table.sort(unsorted)
print("Sorted ascending:", table.concat(unsorted, ", "))

table.sort(unsorted, function(a, b) return a > b end)
print("Sorted descending:", table.concat(unsorted, ", "))

-- table.unpack() - Unpack array to variables
print("\n=== table.unpack() ===")
local coords = {10, 20, 30}
local x, y, z = table.unpack(coords)
print("x:", x, "y:", y, "z:", z)

-- table.pack() - Pack values into array (Lua 5.2+)
print("\n=== table.pack() ===")
local packed = table.pack(1, 2, 3, 4, 5)
print("Packed:", table.concat(packed, ", "))
print("Count:", packed.n)

-- table.move() - Copy elements (Lua 5.3+)
print("\n=== table.move() ===")
local source = {10, 20, 30, 40, 50}
local dest = {}
table.move(source, 1, 3, 1, dest)  -- Copy first 3 elements
print("Moved:", table.concat(dest, ", "))

-- Practical examples
print("\n=== Practical Examples ===")

-- Stack operations
local stack = {}
table.insert(stack, "first")
table.insert(stack, "second")
table.insert(stack, "third")
print("Stack:", table.concat(stack, ", "))
print("Pop:", table.remove(stack))
print("After pop:", table.concat(stack, ", "))

-- Queue operations
local queue = {}
table.insert(queue, "task1")
table.insert(queue, "task2")
table.insert(queue, "task3")
print("\nQueue:", table.concat(queue, ", "))
print("Dequeue:", table.remove(queue, 1))
print("After dequeue:", table.concat(queue, ", "))

-- Reverse array
local function reverse(arr)
    local reversed = {}
    for i = #arr, 1, -1 do
        table.insert(reversed, arr[i])
    end
    return reversed
end

local original = {1, 2, 3, 4, 5}
local rev = reverse(original)
print("\nOriginal:", table.concat(original, ", "))
print("Reversed:", table.concat(rev, ", "))

-- Clear array
local function clear(arr)
    for i = #arr, 1, -1 do
        table.remove(arr)
    end
end

local temp = {1, 2, 3}
print("\nBefore clear:", table.concat(temp, ", "))
clear(temp)
print("After clear: length =", #temp)
