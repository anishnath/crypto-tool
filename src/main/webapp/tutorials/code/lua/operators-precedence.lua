-- Operator Precedence in Lua
-- From highest to lowest priority

-- 1. Exponentiation (^) - Right associative
print("2 ^ 3 ^ 2 =", 2 ^ 3 ^ 2)  -- 512 (same as 2 ^ (3 ^ 2))

-- 2. Unary operators (not, #, -)
print("not true =", not true)
print("#'hello' =", #"hello")
print("-5 =", -5)

-- 3. Multiplication, Division, Modulo (*, /, %, //)
print("10 + 2 * 3 =", 10 + 2 * 3)  -- 16 (not 36)

-- 4. Addition, Subtraction (+, -)
print("5 + 3 - 2 =", 5 + 3 - 2)  -- 6

-- 5. Concatenation (..)
print("'Hello' .. ' ' .. 'World':", "Hello" .. " " .. "World")

-- 6. Relational (<, >, <=, >=, ~=, ==)
print("5 > 3 == true:", 5 > 3 == true)  -- true

-- 7. Logical AND (and)
print("true and false:", true and false)  -- false

-- 8. Logical OR (or)
print("true or false:", true or false)  -- true

-- Use parentheses for clarity!
print("\nWith parentheses:")
print("(10 + 2) * 3 =", (10 + 2) * 3)  -- 36
print("10 + (2 * 3) =", 10 + (2 * 3))  -- 16
