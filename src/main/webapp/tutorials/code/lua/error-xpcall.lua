-- Extended Protected Calls with xpcall() in Lua

-- xpcall() is like pcall() but allows custom error handlers
-- Returns: success (boolean), result or error handler result

print("=== Basic xpcall() Usage ===")

-- Error handler function
local function errorHandler(err)
    return "Error caught: " .. tostring(err)
end

local function riskyFunction(x)
    if x < 0 then
        error("Negative number!")
    end
    return math.sqrt(x)
end

local ok, result = xpcall(function() return riskyFunction(16) end, errorHandler)
print("Success:", ok, "Result:", result)

local ok2, result2 = xpcall(function() return riskyFunction(-4) end, errorHandler)
print("Success:", ok2, "Result:", result2)

-- Error handler with stack trace
print("\n=== Error Handler with Stack Trace ===")

local function detailedErrorHandler(err)
    local trace = debug.traceback(err, 2)
    return trace
end

local function level3()
    error("Error at level 3")
end

local function level2()
    level3()
end

local function level1()
    level2()
end

local ok, result = xpcall(level1, detailedErrorHandler)
if not ok then
    print("Error with trace:")
    print(result)
end

-- Custom error handler with logging
print("\n=== Error Handler with Logging ===")

local errorLog = {}

local function loggingErrorHandler(err)
    local entry = {
        error = tostring(err),
        time = os.time(),
        trace = debug.traceback()
    }
    table.insert(errorLog, entry)
    return "Error logged: " .. tostring(err)
end

local function faultyOperation()
    error("Something went wrong")
end

xpcall(faultyOperation, loggingErrorHandler)
print("Errors logged:", #errorLog)

-- Error handler with context
print("\n=== Error Handler with Context ===")

local function contextErrorHandler(context)
    return function(err)
        return string.format("[%s] %s", context, tostring(err))
    end
end

local ok, result = xpcall(
    function() error("Database error") end,
    contextErrorHandler("DATABASE")
)
print(result)

local ok2, result2 = xpcall(
    function() error("Network error") end,
    contextErrorHandler("NETWORK")
)
print(result2)

-- Error recovery with xpcall
print("\n=== Error Recovery ===")

local function recoveryHandler(err)
    print("Attempting recovery from:", err)
    return "default_value"  -- Fallback value
end

local function unreliableOperation()
    if math.random() > 0.5 then
        error("Random failure")
    end
    return "success"
end

local ok, result = xpcall(unreliableOperation, recoveryHandler)
print("Result:", result)

-- Error handler with cleanup
print("\n=== Error Handler with Cleanup ===")

local resources = {}

local function cleanupErrorHandler(err)
    print("Cleaning up resources...")
    for i, resource in ipairs(resources) do
        if resource.open then
            resource.open = false
            print("Closed resource", i)
        end
    end
    return "Error after cleanup: " .. tostring(err)
end

local function operationWithResources()
    table.insert(resources, {open = true})
    table.insert(resources, {open = true})
    error("Operation failed")
end

xpcall(operationWithResources, cleanupErrorHandler)

-- Nested xpcall
print("\n=== Nested xpcall ===")

local function innerErrorHandler(err)
    return "Inner handler: " .. tostring(err)
end

local function outerErrorHandler(err)
    return "Outer handler: " .. tostring(err)
end

local ok, result = xpcall(function()
    return xpcall(function()
        error("Inner error")
    end, innerErrorHandler)
end, outerErrorHandler)

print("Nested result:", result)

-- Error handler with retry logic
print("\n=== Error Handler with Retry ===")

local retryCount = 0
local maxRetries = 3

local function retryErrorHandler(err)
    retryCount = retryCount + 1
    if retryCount < maxRetries then
        print("Retry", retryCount, "after error:", err)
        return "retry"
    else
        return "Max retries reached: " .. tostring(err)
    end
end

local function unreliableTask()
    if retryCount < 2 then
        error("Not ready yet")
    end
    return "Success!"
end

local result
repeat
    local ok, res = xpcall(unreliableTask, retryErrorHandler)
    if ok then
        result = res
        break
    end
until retryCount >= maxRetries

print("Final result:", result)

-- Error handler with notification
print("\n=== Error Handler with Notification ===")

local notifications = {}

local function notifyErrorHandler(err)
    local notification = {
        type = "error",
        message = tostring(err),
        timestamp = os.date("%Y-%m-%d %H:%M:%S")
    }
    table.insert(notifications, notification)
    print("Notification sent:", notification.message)
    return err
end

xpcall(function()
    error("Critical error occurred")
end, notifyErrorHandler)

print("Total notifications:", #notifications)

-- Comparing pcall and xpcall
print("\n=== pcall vs xpcall ===")

local function testFunction()
    error("Test error")
end

-- pcall - simple error message
local ok1, err1 = pcall(testFunction)
print("pcall error:", err1)

-- xpcall - enhanced error message
local ok2, err2 = xpcall(testFunction, function(err)
    return "Enhanced: " .. tostring(err) .. " [at " .. os.time() .. "]"
end)
print("xpcall error:", err2)

-- Error handler for debugging
print("\n=== Debugging Error Handler ===")

local function debugErrorHandler(err)
    print("=== Error Debug Info ===")
    print("Error:", err)
    print("Stack trace:")
    print(debug.traceback())
    print("======================")
    return err
end

xpcall(function()
    local function deepFunction()
        error("Deep error")
    end
    deepFunction()
end, debugErrorHandler)

-- Production vs Development error handlers
print("\n=== Environment-Specific Handlers ===")

local isDevelopment = true

local function getErrorHandler()
    if isDevelopment then
        return function(err)
            return debug.traceback(err, 2)
        end
    else
        return function(err)
            return "An error occurred. Please contact support."
        end
    end
end

xpcall(function()
    error("Something failed")
end, getErrorHandler())
