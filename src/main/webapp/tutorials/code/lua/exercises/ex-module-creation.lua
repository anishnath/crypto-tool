-- Exercise: Module Creation
-- TODO: Complete the following exercises

-- 1. Create a simple calculator module
local Calculator = {}

function Calculator.add(a, b)
    -- your code here
end

function Calculator.subtract(a, b)
    -- your code here
end

function Calculator.multiply(a, b)
    -- your code here
end

function Calculator.divide(a, b)
    -- your code here
    -- check for division by zero
end

-- return Calculator

-- 2. Create a module with private helper function
local StringUtils = {}

-- Private function
local function isValid(str)
    -- your code here
    -- check if str is a non-empty string
end

function StringUtils.reverse(str)
    -- your code here
    -- use isValid() first
end

function StringUtils.uppercase(str)
    -- your code here
    -- use isValid() first
end

-- return StringUtils

-- 3. Create a counter module with private state
local function createCounter(initial)
    -- Private variable
    local count = initial or 0
    
    -- your code here
    -- return table with increment, decrement, getValue methods
end

-- local counter = createCounter(10)
-- counter.increment()
-- print(counter.getValue())

-- 4. Create a module with configuration
local Config = {}

-- Private config
local settings = {
    debug = false,
    timeout = 30
}

function Config.set(key, value)
    -- your code here
end

function Config.get(key)
    -- your code here
end

-- return Config

-- 5. Create a Logger module with private state
local Logger = {}

-- Private log storage
local logs = {}

function Logger.log(level, message)
    -- your code here
    -- store log with timestamp
end

function Logger.getLogs()
    -- your code here
    -- return copy of logs
end

-- return Logger

-- 6. Create a module with namespace
local App = {}
App.Utils = {}
App.Models = {}

function App.Utils.formatDate(timestamp)
    -- your code here
end

function App.Models.createUser(name, email)
    -- your code here
    -- return user table
end

-- return App
