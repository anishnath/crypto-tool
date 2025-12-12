-- Return Values in Lua

-- Single return value
local function square(x)
    return x * x
end

print("Square of 5:", square(5))

-- Multiple return values
local function divide(a, b)
    if b == 0 then
        return nil, "Division by zero!"
    end
    return a / b, "Success"
end

local result, message = divide(10, 2)
print("Result:", result, "Message:", message)

local result2, message2 = divide(10, 0)
print("Result:", result2, "Message:", message2)

-- Returning multiple values from calculations
local function getStats(numbers)
    local sum = 0
    local count = #numbers
    
    for i, num in ipairs(numbers) do
        sum = sum + num
    end
    
    local average = sum / count
    return sum, average, count
end

local total, avg, cnt = getStats({10, 20, 30, 40, 50})
print(string.format("Sum: %d, Average: %.1f, Count: %d", total, avg, cnt))

-- Returning tables
local function createPoint(x, y)
    return {x = x, y = y}
end

local point = createPoint(10, 20)
print("Point:", point.x, point.y)

-- Early return
local function checkAge(age)
    if age < 0 then
        return false, "Invalid age"
    end
    
    if age < 18 then
        return false, "Too young"
    end
    
    return true, "Valid age"
end

local valid, msg = checkAge(25)
print("Valid:", valid, "Message:", msg)

-- Ignoring return values
local function getThreeValues()
    return 1, 2, 3
end

local a = getThreeValues()  -- Only gets first value
print("a =", a)

local x, y = getThreeValues()  -- Gets first two
print("x =", x, "y =", y)

local p, q, r, s = getThreeValues()  -- Extra var is nil
print("p =", p, "q =", q, "r =", r, "s =", s)

-- Returning functions
local function createMultiplier(factor)
    return function(x)
        return x * factor
    end
end

local double = createMultiplier(2)
local triple = createMultiplier(3)

print("Double 5:", double(5))
print("Triple 5:", triple(5))
