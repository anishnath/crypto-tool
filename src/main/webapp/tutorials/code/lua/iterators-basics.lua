-- Basic Iterator Examples in Lua

-- Using ipairs for arrays (numeric indices)
print("=== Using ipairs ===")
local fruits = {"apple", "banana", "cherry"}

for index, value in ipairs(fruits) do
    print(index, value)
end

-- Using pairs for tables (all key-value pairs)
print("\n=== Using pairs ===")
local person = {
    name = "Alice",
    age = 30,
    city = "New York"
}

for key, value in pairs(person) do
    print(key, value)
end

-- Iterating over a mixed table
print("\n=== Mixed table ===")
local mixed = {
    10, 20, 30,  -- array part
    name = "Bob",  -- hash part
    active = true
}

for k, v in pairs(mixed) do
    print(k, v)
end

-- Generic for loop with custom range
print("\n=== Custom range ===")
for i = 1, 5 do
    print("Number:", i)
end

for i = 10, 1, -2 do
    print("Countdown:", i)
end
