-- Basic Conditionals in Lua

-- Simple if statement
local age = 20

if age >= 18 then
    print("You are an adult")
end

-- if-else
local temperature = 25

if temperature > 30 then
    print("It's hot!")
else
    print("It's comfortable")
end

-- if-elseif-else
local score = 85

if score >= 90 then
    print("Grade: A")
elseif score >= 80 then
    print("Grade: B")
elseif score >= 70 then
    print("Grade: C")
elseif score >= 60 then
    print("Grade: D")
else
    print("Grade: F")
end

-- Multiple conditions with and/or
local hour = 14
local isWeekend = false

if hour >= 9 and hour <= 17 and not isWeekend then
    print("Office hours")
else
    print("Outside office hours")
end

-- Truthiness: only false and nil are falsy
if 0 then print("0 is truthy!") end
if "" then print("Empty string is truthy!") end
if {} then print("Empty table is truthy!") end

-- Checking for nil
local value = nil

if value == nil then
    print("Value is nil")
end

-- Ternary-like expression
local status = (age >= 18) and "Adult" or "Minor"
print("Status:", status)

-- Comparing strings
local name = "Alice"

if name == "Alice" then
    print("Hello, Alice!")
elseif name == "Bob" then
    print("Hello, Bob!")
else
    print("Hello, stranger!")
end
