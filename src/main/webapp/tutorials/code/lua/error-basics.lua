-- Error Handling Basics in Lua

-- Lua provides several ways to handle errors

-- 1. error() function
-- Raises an error and stops execution
print("=== error() function ===")

local function divide(a, b)
    if b == 0 then
        error("Division by zero!")
    end
    return a / b
end

print("10 / 2 =", divide(10, 2))
-- print(divide(10, 0))  -- Would stop execution with error

-- 2. error() with level parameter
-- Level controls where error is reported from
local function validateAge(age)
    if type(age) ~= "number" then
        error("Age must be a number", 2)  -- Report error at caller
    end
    if age < 0 or age > 150 then
        error("Age must be between 0 and 150", 2)
    end
    return true
end

local function createPerson(name, age)
    validateAge(age)  -- Error will be reported here
    return {name = name, age = age}
end

-- 3. assert() function
-- Raises error if condition is false
print("\n=== assert() function ===")

local function sqrt(x)
    assert(x >= 0, "Cannot take square root of negative number")
    return math.sqrt(x)
end

print("sqrt(16) =", sqrt(16))
-- print(sqrt(-4))  -- Would error

-- assert with multiple return values
local function openFile(filename)
    local file, err = io.open(filename, "r")
    assert(file, "Could not open file: " .. (err or "unknown error"))
    return file
end

-- 4. Custom error messages
print("\n=== Custom Error Messages ===")

local function withdraw(balance, amount)
    if amount <= 0 then
        error("Amount must be positive")
    end
    if amount > balance then
        error(string.format(
            "Insufficient funds: balance=%.2f, requested=%.2f",
            balance, amount
        ))
    end
    return balance - amount
end

local balance = 100
balance = withdraw(balance, 30)
print("New balance:", balance)

-- 5. Error objects
-- Errors can be any Lua value, not just strings
print("\n=== Error Objects ===")

local function processData(data)
    if type(data) ~= "table" then
        error({
            code = "INVALID_TYPE",
            message = "Data must be a table",
            expected = "table",
            got = type(data)
        })
    end
    return data
end

-- 6. Stack traces
-- error() includes stack trace information
print("\n=== Stack Traces ===")

local function level3()
    error("Error at level 3")
end

local function level2()
    level3()
end

local function level1()
    level2()
end

-- level1()  -- Would show stack trace

-- 7. Validation patterns
print("\n=== Validation Patterns ===")

local function validateEmail(email)
    if type(email) ~= "string" then
        return false, "Email must be a string"
    end
    if not email:match("@") then
        return false, "Email must contain @"
    end
    return true
end

local valid, err = validateEmail("test@example.com")
if valid then
    print("Email is valid")
else
    print("Invalid email:", err)
end

-- 8. Error handling in constructors
print("\n=== Constructor Validation ===")

local Person = {}
Person.__index = Person

function Person.new(name, age)
    if type(name) ~= "string" or #name == 0 then
        error("Name must be a non-empty string")
    end
    if type(age) ~= "number" or age < 0 then
        error("Age must be a positive number")
    end
    
    local self = setmetatable({}, Person)
    self.name = name
    self.age = age
    return self
end

local person = Person.new("Alice", 25)
print("Created person:", person.name)

-- 9. Graceful degradation
print("\n=== Graceful Degradation ===")

local function safeOperation(x)
    if type(x) ~= "number" then
        return nil, "Input must be a number"
    end
    if x < 0 then
        return nil, "Input must be non-negative"
    end
    return math.sqrt(x)
end

local result, err = safeOperation(16)
if result then
    print("Result:", result)
else
    print("Error:", err)
end

-- 10. Error messages best practices
print("\n=== Best Practices ===")

local function betterError(condition, message, context)
    if not condition then
        local fullMessage = message
        if context then
            fullMessage = fullMessage .. " (context: " .. tostring(context) .. ")"
        end
        error(fullMessage, 2)
    end
end

local function processOrder(order)
    betterError(type(order) == "table", "Order must be a table", type(order))
    betterError(order.id, "Order must have an ID", "missing field: id")
    betterError(order.amount > 0, "Order amount must be positive", order.amount)
    print("Processing order:", order.id)
end

processOrder({id = 123, amount = 99.99})
