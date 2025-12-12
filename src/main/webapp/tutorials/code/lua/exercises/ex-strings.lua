-- Exercise: String Manipulation
-- TODO: Complete the following exercises

-- 1. Create a full name from first and last name
local firstName = "John"
local lastName = "Doe"
local fullName = -- your code here
print("Full name:", fullName)

-- 2. Convert a string to uppercase
local message = "hello world"
local upperMessage = -- your code here
print("Uppercase:", upperMessage)

-- 3. Get the first 3 characters of a string
local word = "Lua Programming"
local first3 = -- your code here (hint: use string.sub)
print("First 3 chars:", first3)

-- 4. Count the length of your name
local myName = "YourName"  -- Replace with your name
local nameLength = -- your code here
print("Name length:", nameLength)

-- 5. Replace "bad" with "good" in a sentence
local sentence = "This is a bad example"
local fixed = -- your code here (hint: use string.gsub)
print("Fixed:", fixed)

-- 6. Check if a string contains "Lua"
local text = "I love Lua programming"
local hasLua = -- your code here (hint: use string.find)
print("Contains 'Lua':", hasLua ~= nil)

-- 7. Format a greeting with name and age
local name = "Alice"
local age = 25
local greeting = -- your code here (hint: use string.format)
print(greeting)
