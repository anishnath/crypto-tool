-- Exercise: Modules
-- TODO: Complete the following exercises

-- 1. Create a simple math utilities module
local MathUtils = {}

function MathUtils.average(numbers)
    -- your code here
    -- calculate and return average of numbers table
end

function MathUtils.max(numbers)
    -- your code here
    -- find and return maximum value
end

function MathUtils.min(numbers)
    -- your code here
    -- find and return minimum value
end

-- local nums = {10, 20, 5, 15, 30}
-- print("Average:", MathUtils.average(nums))
-- print("Max:", MathUtils.max(nums))
-- print("Min:", MathUtils.min(nums))

-- 2. Create a string utilities module with private helper
local StringUtils = {}

-- Private helper function
local function isValid(str)
    -- your code here
    -- check if str is a non-empty string
end

function StringUtils.reverse(str)
    -- your code here
    -- use isValid() then reverse the string
end

function StringUtils.isPalindrome(str)
    -- your code here
    -- check if string is same forwards and backwards
end

-- print(StringUtils.reverse("hello"))
-- print(StringUtils.isPalindrome("racecar"))

-- 3. Create a counter module with private state
local function createCounter(initial)
    -- your code here
    -- return a module with increment, decrement, getValue methods
    -- use closure to keep count private
end

-- local counter = createCounter(10)
-- counter.increment()
-- counter.increment()
-- print("Count:", counter.getValue())

-- 4. Create a logger module with different levels
local Logger = {}

function Logger.info(message)
    -- your code here
    -- print with [INFO] prefix
end

function Logger.error(message)
    -- your code here
    -- print with [ERROR] prefix
end

function Logger.debug(message)
    -- your code here
    -- print with [DEBUG] prefix
end

-- Logger.info("Application started")
-- Logger.error("Something went wrong")
-- Logger.debug("Variable x = 10")

-- 5. Create a module with configuration
local Config = {}
Config.settings = {}

function Config.set(key, value)
    -- your code here
end

function Config.get(key)
    -- your code here
end

function Config.getAll()
    -- your code here
    -- return all settings
end

-- Config.set("debug", true)
-- Config.set("timeout", 30)
-- print("Debug:", Config.get("debug"))
-- print("All settings:", Config.getAll())

-- 6. Create a module that checks for dependencies
local function createModuleWithCheck()
    local M = {}
    
    -- Check if 'math' module is available
    local hasMath = pcall(require, "math")
    
    if hasMath then
        M.mathAvailable = true
        -- your code here
        -- add a function that uses math
    else
        M.mathAvailable = false
    end
    
    return M
end

-- local myModule = createModuleWithCheck()
-- print("Math available?", myModule.mathAvailable)
