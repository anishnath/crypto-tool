-- Functions as First-Class Citizens in Lua

-- Functions can be assigned to variables
print("=== Functions as Variables ===")
local greet = function(name)
    return "Hello, " .. name
end

print(greet("Alice"))

-- Functions can be stored in tables
print("\n=== Functions in Tables ===")
local math_ops = {
    add = function(a, b) return a + b end,
    subtract = function(a, b) return a - b end,
    multiply = function(a, b) return a * b end,
    divide = function(a, b) return a / b end
}

print("5 + 3 =", math_ops.add(5, 3))
print("5 - 3 =", math_ops.subtract(5, 3))
print("5 * 3 =", math_ops.multiply(5, 3))
print("5 / 3 =", math_ops.divide(5, 3))

-- Functions can be passed as arguments
print("\n=== Functions as Arguments ===")
local function apply_operation(a, b, operation)
    return operation(a, b)
end

local function add(x, y) return x + y end
local function multiply(x, y) return x * y end

print("Apply add:", apply_operation(10, 5, add))
print("Apply multiply:", apply_operation(10, 5, multiply))

-- Functions can be returned from other functions
print("\n=== Functions Returning Functions ===")
local function create_multiplier(factor)
    return function(x)
        return x * factor
    end
end

local double = create_multiplier(2)
local triple = create_multiplier(3)

print("Double 5:", double(5))
print("Triple 5:", triple(5))

-- Anonymous functions
print("\n=== Anonymous Functions ===")
local numbers = {1, 2, 3, 4, 5}
local function map(arr, func)
    local result = {}
    for i, v in ipairs(arr) do
        result[i] = func(v)
    end
    return result
end

local squared = map(numbers, function(x) return x * x end)
print("Squared:", table.concat(squared, ", "))

-- Functions as table methods
print("\n=== Functions as Methods ===")
local calculator = {
    value = 0,
    add = function(self, n)
        self.value = self.value + n
        return self
    end,
    multiply = function(self, n)
        self.value = self.value * n
        return self
    end,
    get = function(self)
        return self.value
    end
}

calculator.value = 10
calculator:add(5):multiply(2)
print("Result:", calculator:get())
