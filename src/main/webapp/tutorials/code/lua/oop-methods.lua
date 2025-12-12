-- OOP: Instance and Class Methods

-- Define a class with both instance and class methods
local Counter = {}
Counter.__index = Counter
Counter.totalCounters = 0  -- Class variable

-- Constructor
function Counter.new(name)
    local self = setmetatable({}, Counter)
    self.name = name
    self.count = 0
    Counter.totalCounters = Counter.totalCounters + 1
    return self
end

-- Instance method (uses self)
function Counter:increment()
    self.count = self.count + 1
end

function Counter:getCount()
    return self.count
end

-- Class method (doesn't use self, uses class)
function Counter.getTotalCounters()
    return Counter.totalCounters
end

-- Create instances
local counter1 = Counter.new("Counter1")
local counter2 = Counter.new("Counter2")

counter1:increment()
counter1:increment()
counter2:increment()

print("Counter1:", counter1:getCount())
print("Counter2:", counter2:getCount())
print("Total counters created:", Counter.getTotalCounters())

-- Person class with various methods
local Person = {}
Person.__index = Person

function Person.new(firstName, lastName, age)
    local self = setmetatable({}, Person)
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
    return self
end

-- Instance methods
function Person:getFullName()
    return self.firstName .. " " .. self.lastName
end

function Person:introduce()
    print("Hi, I'm " .. self:getFullName())
end

function Person:birthday()
    self.age = self.age + 1
    print(self:getFullName() .. " is now " .. self.age)
end

function Person:isAdult()
    return self.age >= 18
end

local person = Person.new("John", "Doe", 25)
person:introduce()
print("Full name:", person:getFullName())
print("Is adult:", person:isAdult())
person:birthday()

-- Calculator class with static methods
local Calculator = {}

function Calculator.add(a, b)
    return a + b
end

function Calculator.subtract(a, b)
    return a - b
end

function Calculator.multiply(a, b)
    return a * b
end

function Calculator.divide(a, b)
    if b == 0 then
        error("Division by zero")
    end
    return a / b
end

print("\nCalculator:")
print("5 + 3 =", Calculator.add(5, 3))
print("5 - 3 =", Calculator.subtract(5, 3))
print("5 * 3 =", Calculator.multiply(5, 3))
print("6 / 2 =", Calculator.divide(6, 2))

-- Class with getter and setter methods
local Temperature = {}
Temperature.__index = Temperature

function Temperature.new(celsius)
    local self = setmetatable({}, Temperature)
    self.celsius = celsius or 0
    return self
end

function Temperature:getCelsius()
    return self.celsius
end

function Temperature:setCelsius(value)
    self.celsius = value
end

function Temperature:getFahrenheit()
    return self.celsius * 9/5 + 32
end

function Temperature:setFahrenheit(value)
    self.celsius = (value - 32) * 5/9
end

local temp = Temperature.new(25)
print("\nTemperature:")
print("Celsius:", temp:getCelsius())
print("Fahrenheit:", temp:getFahrenheit())

temp:setFahrenheit(100)
print("After setting to 100°F:")
print("Celsius:", temp:getCelsius())
print("Fahrenheit:", temp:getFahrenheit())

-- Method chaining
local StringBuilder = {}
StringBuilder.__index = StringBuilder

function StringBuilder.new()
    local self = setmetatable({}, StringBuilder)
    self.parts = {}
    return self
end

function StringBuilder:append(str)
    table.insert(self.parts, str)
    return self  -- Return self for chaining
end

function StringBuilder:toString()
    return table.concat(self.parts)
end

local builder = StringBuilder.new()
local result = builder:append("Hello")
                      :append(" ")
                      :append("World")
                      :append("!")
                      :toString()

print("\nString builder result:", result)
