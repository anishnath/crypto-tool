-- While Loops in Lua

-- Basic while loop
print("=== Basic While Loop ===")
local count = 1

while count <= 5 do
    print("Count:", count)
    count = count + 1
end

-- While loop with condition
print("\n=== While with Condition ===")
local sum = 0
local num = 1

while sum < 100 do
    sum = sum + num
    num = num + 1
end

print("Sum:", sum)
print("Numbers added:", num - 1)

-- While loop with break
print("\n=== While with Break ===")
local i = 1

while true do
    if i > 5 then
        break
    end
    print("i =", i)
    i = i + 1
end

-- Repeat-Until Loop (condition checked AFTER)
print("\n=== Repeat-Until Loop ===")
local counter = 1

repeat
    print("Counter:", counter)
    counter = counter + 1
until counter > 5

-- Repeat-until guarantees at least one execution
print("\n=== Repeat-Until (at least once) ===")
local x = 10

repeat
    print("This runs at least once, x =", x)
    x = x + 1
until x > 5  -- Condition is false, but loop ran once!

-- Infinite loop with break condition
print("\n=== Infinite Loop with Break ===")
local attempts = 0

while true do
    attempts = attempts + 1
    print("Attempt:", attempts)
    
    if attempts >= 3 then
        print("Max attempts reached!")
        break
    end
end
