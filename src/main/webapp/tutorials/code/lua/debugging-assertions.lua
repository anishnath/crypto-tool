-- Debugging with Assertions in Lua

-- Basic assertions
print("=== Basic Assertions ===")

-- Assert with custom message
local function divide(a, b)
    assert(b ~= 0, "Division by zero!")
    return a / b
end

print("10 / 2 =", divide(10, 2))

-- This would error:
-- print("10 / 0 =", divide(10, 0))

-- Assertions for type checking
local function greet(name)
    assert(type(name) == "string", "Name must be a string")
    return "Hello, " .. name
end

print(greet("Alice"))
-- print(greet(123))  -- Would error

-- Assertions for range checking
local function set_age(age)
    assert(type(age) == "number", "Age must be a number")
    assert(age >= 0 and age <= 150, "Age must be between 0 and 150")
    return age
end

print("Valid age:", set_age(25))
-- print("Invalid age:", set_age(-5))  -- Would error

-- Assertions in table operations
print("\n=== Table Assertions ===")

local function get_value(t, key)
    assert(type(t) == "table", "First argument must be a table")
    assert(key ~= nil, "Key cannot be nil")
    return t[key]
end

local data = {name = "Bob", age = 30}
print("Name:", get_value(data, "name"))

-- Precondition and postcondition assertions
local function factorial(n)
    -- Precondition
    assert(type(n) == "number" and n >= 0 and n == math.floor(n), 
           "Input must be a non-negative integer")
    
    local result = 1
    for i = 2, n do
        result = result * i
    end
    
    -- Postcondition
    assert(result > 0, "Result must be positive")
    
    return result
end

print("\n=== Factorial with Assertions ===")
print("5! =", factorial(5))
print("0! =", factorial(0))

-- Assertions in class methods
print("\n=== Class Assertions ===")

BankAccount = {}
BankAccount.__index = BankAccount

function BankAccount:new(initial_balance)
    assert(type(initial_balance) == "number" and initial_balance >= 0,
           "Initial balance must be a non-negative number")
    
    local instance = setmetatable({}, self)
    instance.balance = initial_balance
    return instance
end

function BankAccount:deposit(amount)
    assert(type(amount) == "number" and amount > 0,
           "Deposit amount must be a positive number")
    
    self.balance = self.balance + amount
end

function BankAccount:withdraw(amount)
    assert(type(amount) == "number" and amount > 0,
           "Withdrawal amount must be a positive number")
    assert(amount <= self.balance,
           string.format("Insufficient funds. Balance: %.2f, Requested: %.2f",
                        self.balance, amount))
    
    self.balance = self.balance - amount
end

local account = BankAccount:new(1000)
account:deposit(500)
print("Balance after deposit:", account.balance)

account:withdraw(200)
print("Balance after withdrawal:", account.balance)

-- This would error:
-- account:withdraw(2000)  -- Insufficient funds

-- Custom assertion function
print("\n=== Custom Assertions ===")

local function assert_positive(value, name)
    assert(type(value) == "number" and value > 0,
           string.format("%s must be a positive number, got %s", 
                        name or "Value", tostring(value)))
end

local function calculate_area(width, height)
    assert_positive(width, "Width")
    assert_positive(height, "Height")
    return width * height
end

print("Area (5x3):", calculate_area(5, 3))
-- print("Area (-5x3):", calculate_area(-5, 3))  -- Would error

-- Conditional assertions (debug mode)
local DEBUG = true

local function debug_assert(condition, message)
    if DEBUG then
        assert(condition, message)
    end
end

local function process_data(data)
    debug_assert(type(data) == "table", "Data must be a table")
    debug_assert(#data > 0, "Data cannot be empty")
    
    print("Processing", #data, "items")
end

process_data({1, 2, 3, 4, 5})

print("\n=== Assertions Complete ===")
print("All assertions passed successfully!")
