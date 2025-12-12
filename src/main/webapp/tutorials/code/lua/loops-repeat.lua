-- Repeat-Until Loops

-- Basic repeat-until
print("=== Basic Repeat-Until ===")
local count = 1

repeat
    print("Count:", count)
    count = count + 1
until count > 5

-- Key difference: condition checked AFTER
print("\n=== Condition Checked After ===")
local x = 10

repeat
    print("x =", x, "(runs even though x > 5)")
    x = x + 1
until x > 5

-- Menu-driven program pattern
print("\n=== Menu Pattern ===")
local choice = 0
local attempts = 0

repeat
    attempts = attempts + 1
    print("\nMenu:")
    print("1. Option A")
    print("2. Option B")
    print("3. Exit")
    
    -- Simulate user input
    if attempts == 1 then choice = 1
    elseif attempts == 2 then choice = 2
    else choice = 3 end
    
    print("You chose:", choice)
    
    if choice == 1 then
        print("Executing Option A")
    elseif choice == 2 then
        print("Executing Option B")
    elseif choice == 3 then
        print("Exiting...")
    end
until choice == 3

-- Input validation pattern
print("\n=== Input Validation ===")
local number
local tries = 0

repeat
    tries = tries + 1
    -- Simulate getting input
    number = tries * 10
    print("Attempt", tries, "- Number:", number)
until number >= 50

print("Valid number found:", number)

-- Repeat-until with break
print("\n=== Repeat-Until with Break ===")
local counter = 0

repeat
    counter = counter + 1
    print("Counter:", counter)
    
    if counter == 3 then
        print("Breaking early!")
        break
    end
until counter >= 10

print("Final counter:", counter)
