-- Lua Pattern Matching (simpler than regex)

local text = "The price is $25.99 and the code is ABC123"

-- Basic pattern matching
print("=== Basic Patterns ===")
print("Find number:", string.match(text, "%d+"))
print("Find letters:", string.match(text, "%a+"))
print("Find word:", string.match(text, "%w+"))

-- Pattern classes
-- %a = letters, %d = digits, %w = alphanumeric
-- %s = space, %p = punctuation, %x = hexadecimal

-- Find all numbers
print("\n=== Find All Numbers ===")
for num in string.gmatch(text, "%d+") do
    print("Found:", num)
end

-- Find all words
print("\n=== Find All Words ===")
for word in string.gmatch(text, "%a+") do
    print("Word:", word)
end

-- Replace patterns
print("\n=== Replace Patterns ===")
local censored = string.gsub(text, "%d", "X")
print("Numbers censored:", censored)

-- Capture groups
print("\n=== Capture Groups ===")
local email = "user@example.com"
local username, domain = string.match(email, "(%w+)@(%w+%.%w+)")
print("Username:", username)
print("Domain:", domain)

-- Split string
print("\n=== Split String ===")
local csv = "apple,banana,cherry"
for fruit in string.gmatch(csv, "([^,]+)") do
    print("Fruit:", fruit)
end

-- Validate patterns
print("\n=== Validation ===")
local phone = "123-456-7890"
if string.match(phone, "%d%d%d%-%d%d%d%-%d%d%d%d") then
    print("Valid phone number!")
end
