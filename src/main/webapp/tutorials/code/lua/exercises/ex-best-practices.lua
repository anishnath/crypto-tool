-- Exercise: Best Practices
-- TODO: Complete the following exercises

-- 1. Refactor this code to use local variables
x = 10
y = 20
function add()
    return x + y
end

-- Refactored version:
-- local x = 10
-- local y = 20
-- local function add()
--     return x + y
-- end

-- 2. Improve this string concatenation
local function buildString()
    local s = ""
    for i = 1, 1000 do
        s = s .. tostring(i) .. ","
    end
    return s
end

-- Improved version using table.concat:
-- local function buildStringBetter()
--     -- your code here
-- end

-- 3. Fix the naming conventions
local function f(x, y)
    local r = x + y
    return r
end

-- Fixed version:
-- local function calculateSum(firstNumber, secondNumber)
--     -- your code here
-- end

-- 4. Improve error handling
local function divide(a, b)
    return a / b
end

-- Improved version:
-- local function safeDivide(a, b)
--     -- your code here
--     -- check for errors and return nil, error
-- end

-- 5. Optimize this table lookup
local config = {
    settings = {
        timeout = 30,
        retries = 3
    }
}

local function processItems(items)
    for i = 1, #items do
        print(config.settings.timeout)
    end
end

-- Optimized version:
-- local function processItemsOptimized(items)
--     -- your code here
--     -- cache the timeout value
-- end

-- 6. Refactor to avoid deep nesting
local function checkUser(data)
    if data then
        if data.user then
            if data.user.profile then
                if data.user.profile.active then
                    return true
                end
            end
        end
    end
    return false
end

-- Refactored version:
-- local function checkUserBetter(data)
--     -- your code here
--     -- use early returns
-- end

-- 7. Create a well-structured module
-- TODO: Create a module with:
-- - Module table
-- - Constants
-- - Private functions
-- - Public functions
-- - Proper return statement

local MyModule = {}

-- your code here

-- return MyModule

-- 8. Add proper comments and documentation
local function process(x, y)
    return x * y + x / y
end

-- Documented version:
-- --- Processes two numbers with a complex calculation
-- -- @param x number The first number
-- -- @param y number The second number
-- -- @return number The calculated result
-- local function process(x, y)
--     -- your code here
-- end

-- 9. Improve this code's performance
local function slowFunction()
    for i = 1, 10000 do
        local temp = {x = i, y = i * 2}
        -- process temp
    end
end

-- Optimized version:
-- local function fastFunction()
--     -- your code here
--     -- reuse the temp table
-- end

-- 10. Fix the style issues
local function badStyle(a,b,c)
local result=a+b+c
return result
end

-- Fixed version:
-- local function goodStyle(a, b, c)
--     -- your code here
--     -- proper spacing and formatting
-- end
