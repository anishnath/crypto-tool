-- Exercise: Error Handling
-- TODO: Complete the following exercises

-- 1. Create a safe division function using pcall
local function safeDivide(a, b)
    -- your code here
    -- use pcall to catch division by zero
    -- return result or nil, error
end

-- print(safeDivide(10, 2))
-- print(safeDivide(10, 0))

-- 2. Create a function that validates user input
local function validateUser(user)
    -- your code here
    -- check if user is a table
    -- check if user has name and age
    -- use assert() for validation
end

-- local ok, err = pcall(validateUser, {name = "Alice", age = 25})
-- print(ok, err)

-- 3. Create a retry function
local function retry(func, maxAttempts)
    -- your code here
    -- try to call func up to maxAttempts times
    -- return result on success or nil, error on failure
end

-- local result = retry(function()
--     if math.random() > 0.7 then
--         return "Success!"
--     else
--         error("Failed")
--     end
-- end, 5)

-- 4. Create an error handler with logging
local errorLog = {}

local function loggingErrorHandler(err)
    -- your code here
    -- log error with timestamp
    -- return formatted error message
end

-- xpcall(function() error("Test") end, loggingErrorHandler)

-- 5. Create a safe file reader
local function safeReadFile(filename)
    -- your code here
    -- use pcall to safely open and read file
    -- return content or nil, error
end

-- local content, err = safeReadFile("test.txt")

-- 6. Create a function with custom error objects
local function processData(data)
    -- your code here
    -- validate data
    -- throw error object with code and message
    -- example: error({code = "INVALID", message = "..."})
end

-- local ok, err = pcall(processData, "invalid")
-- if not ok then
--     print("Error code:", err.code)
--     print("Error message:", err.message)
-- end

-- 7. Create a safe JSON parser (simulated)
local function safeParseJSON(str)
    -- your code here
    -- validate JSON string
    -- return parsed data or nil, error
end

-- local data, err = safeParseJSON('{"name": "Alice"}')

-- 8. Create error handler with stack trace
local function traceErrorHandler(err)
    -- your code here
    -- use debug.traceback()
    -- return error with stack trace
end

-- xpcall(function() error("Test") end, traceErrorHandler)
