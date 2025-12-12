-- For Loops in Lua

-- Numeric for loop (basic)
print("=== Basic For Loop ===")
for i = 1, 5 do
    print("i =", i)
end

-- For loop with step
print("\n=== For Loop with Step ===")
for i = 0, 10, 2 do  -- start, end, step
    print("Even:", i)
end

-- Counting backwards
print("\n=== Counting Backwards ===")
for i = 5, 1, -1 do
    print("Countdown:", i)
end
print("Blast off!")

-- For loop with calculations
print("\n=== Multiplication Table ===")
local number = 5

for i = 1, 10 do
    print(number, "x", i, "=", number * i)
end

-- Nested for loops
print("\n=== Nested Loops (Grid) ===")
for row = 1, 3 do
    for col = 1, 3 do
        io.write("(" .. row .. "," .. col .. ") ")
    end
    print()  -- New line
end

-- Sum with for loop
print("\n=== Sum 1 to 100 ===")
local sum = 0

for i = 1, 100 do
    sum = sum + i
end

print("Sum:", sum)

-- For loop with break
print("\n=== For Loop with Break ===")
for i = 1, 10 do
    if i == 6 then
        print("Breaking at", i)
        break
    end
    print("i =", i)
end

-- Factorial calculation
print("\n=== Factorial ===")
local n = 5
local factorial = 1

for i = 1, n do
    factorial = factorial * i
end

print(n .. "! =", factorial)
