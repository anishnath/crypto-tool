-- Protected Calls with pcall() in Lua

-- pcall() (protected call) catches errors without stopping execution
-- Returns: success (boolean), result or error message

print("=== Basic pcall() Usage ===")

local function riskyFunction(x)
    if x < 0 then
        error("Negative number not allowed!")
    end
    return math.sqrt(x)
end

-- Without pcall - would crash
-- local result = riskyFunction(-4)

-- With pcall - catches error
local success, result = pcall(riskyFunction, 16)
if success then
    print("Result:", result)
else
    print("Error caught:", result)
end

local success2, result2 = pcall(riskyFunction, -4)
if success2 then
    print("Result:", result2)
else
    print("Error caught:", result2)
end

-- pcall with multiple arguments
print("\n=== pcall() with Multiple Arguments ===")

local function divide(a, b)
    if b == 0 then
        error("Division by zero")
    end
    return a / b
end

local ok, result = pcall(divide, 10, 2)
print("10 / 2:", ok, result)

local ok2, result2 = pcall(divide, 10, 0)
print("10 / 0:", ok2, result2)

-- pcall with anonymous functions
print("\n=== pcall() with Anonymous Functions ===")

local ok, result = pcall(function()
    local x = 10
    local y = 0
    if y == 0 then
        error("Cannot divide by zero")
    end
    return x / y
end)

if not ok then
    print("Error:", result)
end

-- pcall for file operations
print("\n=== pcall() for File Operations ===")

local function readFile(filename)
    local file = io.open(filename, "r")
    if not file then
        error("File not found: " .. filename)
    end
    local content = file:read("*all")
    file:close()
    return content
end

local ok, content = pcall(readFile, "nonexistent.txt")
if ok then
    print("File content:", content)
else
    print("Could not read file:", content)
end

-- pcall for JSON parsing (simulated)
print("\n=== pcall() for Parsing ===")

local function parseJSON(str)
    if str == "" then
        error("Empty JSON string")
    end
    if not str:match("^%s*{") then
        error("Invalid JSON format")
    end
    -- Simulated parsing
    return {parsed = true}
end

local ok, data = pcall(parseJSON, '{"name": "Alice"}')
if ok then
    print("Parsed successfully")
else
    print("Parse error:", data)
end

-- pcall in a loop
print("\n=== pcall() in Loop ===")

local operations = {
    function() return 10 / 2 end,
    function() return 10 / 0 end,  -- Error
    function() return 10 / 5 end,
    function() error("Custom error") end
}

for i, op in ipairs(operations) do
    local ok, result = pcall(op)
    if ok then
        print(i .. ". Success:", result)
    else
        print(i .. ". Failed:", result)
    end
end

-- pcall with module loading
print("\n=== pcall() with require() ===")

local function loadModule(name)
    local ok, module = pcall(require, name)
    if ok then
        print("Loaded module:", name)
        return module
    else
        print("Failed to load:", name)
        return nil
    end
end

local math = loadModule("math")
local fake = loadModule("nonexistent_module")

-- pcall for validation
print("\n=== pcall() for Validation ===")

local function validateUser(user)
    assert(type(user) == "table", "User must be a table")
    assert(user.name, "User must have a name")
    assert(user.age and user.age > 0, "User must have valid age")
    return true
end

local users = {
    {name = "Alice", age = 25},
    {name = "Bob"},  -- Missing age
    "invalid",  -- Not a table
}

for i, user in ipairs(users) do
    local ok, err = pcall(validateUser, user)
    if ok then
        print(i .. ". Valid user")
    else
        print(i .. ". Invalid:", err)
    end
end

-- pcall with cleanup
print("\n=== pcall() with Cleanup ===")

local function processWithCleanup()
    local resource = {open = true}
    
    local ok, result = pcall(function()
        -- Simulated processing
        if math.random() > 0.5 then
            error("Random error")
        end
        return "Success"
    end)
    
    -- Cleanup always happens
    resource.open = false
    print("Resource cleaned up")
    
    if ok then
        return result
    else
        return nil, result
    end
end

-- Retry pattern with pcall
print("\n=== Retry Pattern ===")

local function retryOperation(func, maxAttempts)
    for attempt = 1, maxAttempts do
        local ok, result = pcall(func)
        if ok then
            print("Success on attempt", attempt)
            return result
        else
            print("Attempt", attempt, "failed:", result)
            if attempt < maxAttempts then
                print("Retrying...")
            end
        end
    end
    return nil, "All attempts failed"
end

local attempts = 0
local result = retryOperation(function()
    attempts = attempts + 1
    if attempts < 3 then
        error("Not ready yet")
    end
    return "Finally worked!"
end, 5)

print("Final result:", result)

-- pcall vs direct call
print("\n=== pcall() vs Direct Call ===")

local function safeCall(func, ...)
    local ok, result = pcall(func, ...)
    if ok then
        return result
    else
        print("Error handled:", result)
        return nil
    end
end

local result1 = safeCall(math.sqrt, 16)
print("Safe sqrt(16):", result1)

local result2 = safeCall(function(x)
    if x < 0 then error("Negative!") end
    return math.sqrt(x)
end, -4)
print("Safe sqrt(-4):", result2)
