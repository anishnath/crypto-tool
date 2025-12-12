-- Arithmetic Operators
local a = 10
local b = 3

print("=== Arithmetic Operators ===")
print("a + b =", a + b)   -- Addition: 13
print("a - b =", a - b)   -- Subtraction: 7
print("a * b =", a * b)   -- Multiplication: 30
print("a / b =", a / b)   -- Division: 3.333...
print("a % b =", a % b)   -- Modulo (remainder): 1
print("a ^ b =", a ^ b)   -- Exponentiation: 1000
print("a // b =", a // b) -- Floor division: 3 (Lua 5.3+)

-- Unary minus
print("-a =", -a)         -- Negation: -10

-- Relational Operators
print("\n=== Relational Operators ===")
print("a == b:", a == b)  -- Equal to: false
print("a ~= b:", a ~= b)  -- Not equal to: true
print("a > b:", a > b)    -- Greater than: true
print("a < b:", a < b)    -- Less than: false
print("a >= b:", a >= b)  -- Greater or equal: true
print("a <= b:", a <= b)  -- Less or equal: false

-- Logical Operators
print("\n=== Logical Operators ===")
local x = true
local y = false

print("x and y:", x and y)  -- Logical AND: false
print("x or y:", x or y)    -- Logical OR: true
print("not x:", not x)      -- Logical NOT: false
print("not y:", not y)      -- Logical NOT: true

-- String Concatenation
print("\n=== String Concatenation ===")
local first = "Hello"
local last = "World"
print(first .. " " .. last)  -- "Hello World"

-- Length Operator
print("\n=== Length Operator ===")
local str = "Lua"
local arr = {10, 20, 30, 40}
print("#str =", #str)  -- Length of string: 3
print("#arr =", #arr)  -- Length of array: 4
