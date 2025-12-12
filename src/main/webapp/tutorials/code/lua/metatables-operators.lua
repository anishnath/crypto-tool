-- Operator Overloading with Metatables

-- Arithmetic operators
print("=== Arithmetic Operators ===")

local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
    local v = {x = x, y = y}
    setmetatable(v, Vector)
    return v
end

-- __add (addition)
Vector.__add = function(a, b)
    return Vector.new(a.x + b.x, a.y + b.y)
end

-- __sub (subtraction)
Vector.__sub = function(a, b)
    return Vector.new(a.x - b.x, a.y - b.y)
end

-- __mul (multiplication - scalar)
Vector.__mul = function(a, b)
    if type(a) == "number" then
        return Vector.new(a * b.x, a * b.y)
    else
        return Vector.new(a.x * b, a.y * b)
    end
end

-- __div (division)
Vector.__div = function(a, b)
    return Vector.new(a.x / b, a.y / b)
end

-- __unm (unary minus)
Vector.__unm = function(a)
    return Vector.new(-a.x, -a.y)
end

-- __tostring (for printing)
Vector.__tostring = function(v)
    return string.format("(%.2f, %.2f)", v.x, v.y)
end

local v1 = Vector.new(3, 4)
local v2 = Vector.new(1, 2)

print("v1:", v1)
print("v2:", v2)
print("v1 + v2:", v1 + v2)
print("v1 - v2:", v1 - v2)
print("v1 * 2:", v1 * 2)
print("v1 / 2:", v1 / 2)
print("-v1:", -v1)

-- Comparison operators
print("\n=== Comparison Operators ===")

-- __eq (equality)
Vector.__eq = function(a, b)
    return a.x == b.x and a.y == b.y
end

-- __lt (less than)
Vector.__lt = function(a, b)
    return a.x < b.x or (a.x == b.x and a.y < b.y)
end

-- __le (less than or equal)
Vector.__le = function(a, b)
    return a.x <= b.x and a.y <= b.y
end

local v3 = Vector.new(3, 4)
print("v1 == v3:", v1 == v3)
print("v1 < v2:", v1 < v2)
print("v2 <= v1:", v2 <= v1)

-- Concatenation operator
print("\n=== Concatenation ===")

local String = {}
String.__index = String

function String.new(value)
    return setmetatable({value = value}, String)
end

String.__concat = function(a, b)
    local aVal = type(a) == "table" and a.value or a
    local bVal = type(b) == "table" and b.value or b
    return String.new(aVal .. bVal)
end

String.__tostring = function(s)
    return s.value
end

local s1 = String.new("Hello")
local s2 = String.new(" World")
print("s1 .. s2:", s1 .. s2)

-- Length operator
print("\n=== Length Operator ===")

local CustomArray = {}
CustomArray.__index = CustomArray

function CustomArray.new()
    return setmetatable({items = {}}, CustomArray)
end

function CustomArray:add(value)
    table.insert(self.items, value)
end

CustomArray.__len = function(arr)
    return #arr.items
end

local arr = CustomArray.new()
arr:add(10)
arr:add(20)
arr:add(30)
print("Array length:", #arr)

-- Call operator
print("\n=== Call Operator ===")

local Multiplier = {}
Multiplier.__index = Multiplier

function Multiplier.new(factor)
    return setmetatable({factor = factor}, Multiplier)
end

Multiplier.__call = function(m, value)
    return m.factor * value
end

local double = Multiplier.new(2)
local triple = Multiplier.new(3)

print("double(5):", double(5))
print("triple(5):", triple(5))

-- Index operator
print("\n=== Index Operator ===")

local SafeTable = {}
SafeTable.__index = function(t, key)
    error("Key '" .. key .. "' does not exist!")
end

local safe = setmetatable({x = 10}, SafeTable)
print("safe.x:", safe.x)
-- print(safe.y)  -- Would error!

-- Modulo operator
print("\n=== Modulo Operator ===")

Vector.__mod = function(a, b)
    return Vector.new(a.x % b, a.y % b)
end

local v4 = Vector.new(10, 15)
print("v4 % 3:", v4 % 3)

-- Power operator
print("\n=== Power Operator ===")

Vector.__pow = function(a, b)
    return Vector.new(a.x ^ b, a.y ^ b)
end

local v5 = Vector.new(2, 3)
print("v5 ^ 2:", v5 ^ 2)
