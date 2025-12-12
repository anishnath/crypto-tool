-- Lua Best Practices: Style Guide

-- 1. Indentation: Use 2 or 4 spaces (be consistent)
print("=== Indentation ===")

-- Good (2 spaces)
local function example1()
  if true then
    print("Hello")
  end
end

-- Good (4 spaces)
local function example2()
    if true then
        print("Hello")
    end
end

-- Bad (mixed)
local function bad()
  if true then
      print("Inconsistent")
    end
end

-- 2. Naming conventions
print("\n=== Naming Conventions ===")

-- Variables and functions: camelCase or snake_case
local userName = "Alice"
local user_name = "Alice"  -- Both acceptable, be consistent

-- Constants: UPPER_CASE
local MAX_SIZE = 100
local DEFAULT_TIMEOUT = 30

-- Classes/Modules: PascalCase
local MyClass = {}
local StringUtils = {}

-- Private functions: prefix with underscore
local function _privateHelper()
    return "private"
end

-- Boolean variables: use is/has prefix
local isActive = true
local hasPermission = false

-- 3. Spacing
print("\n=== Spacing ===")

-- Good spacing
local x = 10 + 20
local result = calculate(a, b, c)
local data = {name = "Alice", age = 25}

-- Bad spacing
local y=10+20
local result2=calculate(a,b,c)
local data2={name="Alice",age=25}

-- 4. Line length
print("\n=== Line Length ===")

-- Keep lines under 80-100 characters
-- Break long lines

-- Bad
local veryLongFunctionName = function(firstParameter, secondParameter, thirdParameter, fourthParameter)
    return firstParameter + secondParameter + thirdParameter + fourthParameter
end

-- Good
local veryLongFunctionName = function(
    firstParameter,
    secondParameter,
    thirdParameter,
    fourthParameter
)
    return firstParameter + secondParameter +
           thirdParameter + fourthParameter
end

-- 5. Comments
print("\n=== Comments ===")

-- Single-line comments for brief explanations
local count = 0  -- Initialize counter

--[[
Multi-line comments for longer explanations
or documentation blocks
]]

--- Documentation style comment
-- @param x number The input value
-- @return number The squared value
local function square(x)
    return x * x
end

-- 6. Function declarations
print("\n=== Function Declarations ===")

-- Prefer local functions
local function goodFunction()
    return "local"
end

-- Avoid global functions
function badFunction()  -- Creates global
    return "global"
end

-- Method syntax for tables
local MyObject = {}

function MyObject:method()  -- Good for methods
    return self.value
end

function MyObject.staticMethod()  -- Good for static
    return "static"
end

-- 7. Table constructors
print("\n=== Table Constructors ===")

-- Good: One line for simple tables
local point = {x = 10, y = 20}

-- Good: Multiple lines for complex tables
local person = {
    name = "Alice",
    age = 25,
    address = {
        city = "New York",
        zip = "10001"
    }
}

-- Good: Trailing comma allowed
local colors = {
    "red",
    "green",
    "blue",  -- Trailing comma OK
}

-- 8. String quotes
print("\n=== String Quotes ===")

-- Use double quotes for strings
local message = "Hello, World!"

-- Use single quotes for strings with double quotes inside
local html = '<div class="container">Content</div>'

-- Use [[]] for multi-line strings
local multiline = [[
This is a
multi-line
string
]]

-- 9. Conditional statements
print("\n=== Conditionals ===")

-- Good: Clear and readable
if condition then
    doSomething()
elseif otherCondition then
    doSomethingElse()
else
    doDefault()
end

-- Good: Simple one-liners
if x > 0 then return x end

-- Avoid: Ternary-style (Lua doesn't have ternary)
-- Use: and/or pattern carefully
local value = condition and trueValue or falseValue

-- 10. Loops
print("\n=== Loops ===")

-- Good: Use appropriate loop type
for i = 1, 10 do
    print(i)
end

for i, v in ipairs(array) do
    print(i, v)
end

for k, v in pairs(table) do
    print(k, v)
end

while condition do
    doSomething()
end

-- 11. Error handling
print("\n=== Error Handling ===")

-- Good: Return nil, error for recoverable errors
local function divide(a, b)
    if b == 0 then
        return nil, "Division by zero"
    end
    return a / b
end

-- Good: Use error() for unrecoverable errors
local function mustSucceed(value)
    if not value then
        error("Value is required", 2)
    end
    return value
end

-- Good: Use pcall for risky operations
local ok, result = pcall(riskyFunction)
if not ok then
    print("Error:", result)
end

-- 12. Module structure
print("\n=== Module Structure ===")

-- Good module pattern
local M = {}

-- Constants at top
M.VERSION = "1.0.0"

-- Private functions
local function helper()
    return "private"
end

-- Public functions
function M.publicFunction()
    return helper()
end

-- Return module
-- return M

-- 13. Avoid magic numbers
print("\n=== Magic Numbers ===")

-- Bad
if user.age > 18 then
    -- ...
end

-- Good
local ADULT_AGE = 18
if user.age > ADULT_AGE then
    -- ...
end

-- 14. Use descriptive names
print("\n=== Descriptive Names ===")

-- Bad
local function f(x, y)
    return x + y
end

-- Good
local function calculateSum(firstNumber, secondNumber)
    return firstNumber + secondNumber
end

-- 15. Consistent style
print("\n=== Consistency ===")

-- Pick a style and stick to it throughout your project
-- Examples:
-- - camelCase vs snake_case
-- - 2 spaces vs 4 spaces
-- - Single quotes vs double quotes
-- - Function declaration style

-- Document your style guide and follow it!
