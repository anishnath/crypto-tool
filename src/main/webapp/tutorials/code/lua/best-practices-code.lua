-- Lua Best Practices: Code Organization

-- 1. Always use local variables
print("=== Use Local Variables ===")

-- Bad
globalVar = 10  -- Pollutes global namespace

-- Good
local localVar = 10  -- Scoped properly

-- 2. Declare variables at the top
print("\n=== Variable Declaration ===")

local function processData(data)
    -- Declare all locals at the top
    local result
    local temp
    local count = 0
    
    -- Then use them
    for i, v in ipairs(data) do
        count = count + 1
    end
    
    return count
end

-- 3. Use meaningful names
print("\n=== Meaningful Names ===")

-- Bad
local function f(x, y)
    return x + y
end

-- Good
local function calculateSum(firstNumber, secondNumber)
    return firstNumber + secondNumber
end

-- 4. Module structure
print("\n=== Module Structure ===")

-- Good module pattern
local MyModule = {}

-- Private functions
local function privateHelper()
    return "private"
end

-- Public functions
function MyModule.publicFunction()
    return privateHelper() .. " to public"
end

-- Module metadata
MyModule._VERSION = "1.0.0"
MyModule._DESCRIPTION = "Example module"

-- Return module
-- return MyModule

-- 5. Error handling
print("\n=== Error Handling ===")

-- Bad
local function divide(a, b)
    return a / b  -- No error checking
end

-- Good
local function safeDivide(a, b)
    if type(a) ~= "number" or type(b) ~= "number" then
        return nil, "Arguments must be numbers"
    end
    if b == 0 then
        return nil, "Division by zero"
    end
    return a / b
end

-- 6. Function organization
print("\n=== Function Organization ===")

-- Group related functions
local StringUtils = {}

function StringUtils.trim(s)
    return s:match("^%s*(.-)%s*$")
end

function StringUtils.split(s, delimiter)
    local result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function StringUtils.capitalize(s)
    return string.upper(string.sub(s, 1, 1)) .. string.sub(s, 2)
end

-- 7. Constants
print("\n=== Constants ===")

-- Use uppercase for constants
local MAX_SIZE = 100
local DEFAULT_TIMEOUT = 30
local API_VERSION = "v1"

local Config = {
    MAX_RETRIES = 3,
    TIMEOUT = 5000,
    DEBUG = false
}

-- 8. Table constructors
print("\n=== Table Constructors ===")

-- Bad
local person = {}
person.name = "Alice"
person.age = 25

-- Good
local person = {
    name = "Alice",
    age = 25
}

-- 9. Comments
print("\n=== Comments ===")

-- Single-line comment for brief explanations

--[[
Multi-line comment for longer explanations
or documentation blocks
]]

--- Documentation comment
-- @param x number The first number
-- @param y number The second number
-- @return number The sum
local function add(x, y)
    return x + y
end

-- 10. Code formatting
print("\n=== Code Formatting ===")

-- Consistent indentation (2 or 4 spaces)
local function example()
    if true then
        local x = 10
        if x > 5 then
            print("Greater than 5")
        end
    end
end

-- Spaces around operators
local result = 10 + 20  -- Good
local bad = 10+20  -- Bad

-- 11. Return early pattern
print("\n=== Return Early ===")

-- Bad
local function processUser(user)
    if user then
        if user.active then
            if user.age >= 18 then
                return "Valid"
            end
        end
    end
    return "Invalid"
end

-- Good
local function processUserBetter(user)
    if not user then return "Invalid" end
    if not user.active then return "Invalid" end
    if user.age < 18 then return "Invalid" end
    return "Valid"
end

-- 12. Avoid deep nesting
print("\n=== Avoid Deep Nesting ===")

-- Bad
local function deepNesting(data)
    if data then
        if data.user then
            if data.user.profile then
                return data.user.profile.name
            end
        end
    end
    return nil
end

-- Good
local function shallowNesting(data)
    if not data then return nil end
    if not data.user then return nil end
    if not data.user.profile then return nil end
    return data.user.profile.name
end

-- 13. Use table.insert for arrays
print("\n=== Array Operations ===")

-- Good
local items = {}
table.insert(items, "first")
table.insert(items, "second")

-- Also good for specific index
table.insert(items, 1, "at beginning")

-- 14. Consistent naming conventions
print("\n=== Naming Conventions ===")

-- Variables and functions: camelCase or snake_case
local userName = "Alice"
local user_name = "Alice"

-- Constants: UPPER_CASE
local MAX_CONNECTIONS = 100

-- Classes/Modules: PascalCase
local MyClass = {}

-- Private: prefix with underscore
local function _privateFunction()
    return "private"
end

-- 15. File organization
print("\n=== File Organization ===")

--[[
Recommended file structure:

1. Module declaration
2. Dependencies (require statements)
3. Constants
4. Private functions
5. Public functions
6. Return module

Example:

local MyModule = {}

-- Dependencies
local utils = require("utils")

-- Constants
local VERSION = "1.0.0"

-- Private
local function helper()
end

-- Public
function MyModule.doSomething()
end

return MyModule
]]
