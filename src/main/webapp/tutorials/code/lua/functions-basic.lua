-- Function Basics in Lua

-- Simple function definition
local function greet()
    print("Hello, Lua!")
end

greet()  -- Call the function

-- Function with parameters
local function greetPerson(name)
    print("Hello, " .. name .. "!")
end

greetPerson("Alice")
greetPerson("Bob")

-- Function with return value
local function add(a, b)
    return a + b
end

local result = add(5, 3)
print("5 + 3 =", result)

-- Function with multiple return values
local function getMinMax(a, b, c)
    local min = math.min(a, b, c)
    local max = math.max(a, b, c)
    return min, max
end

local minimum, maximum = getMinMax(10, 5, 15)
print("Min:", minimum, "Max:", maximum)

-- Function without return (returns nil)
local function sayHello()
    print("Hello!")
    -- No return statement
end

local value = sayHello()
print("Return value:", value)  -- nil

-- Local vs global functions
local function localFunc()
    print("I'm local")
end

function globalFunc()  -- No 'local' keyword
    print("I'm global (avoid this!)")
end

localFunc()
globalFunc()

-- Function stored in variable
local myFunc = function(x)
    return x * 2
end

print("Double 5:", myFunc(5))
