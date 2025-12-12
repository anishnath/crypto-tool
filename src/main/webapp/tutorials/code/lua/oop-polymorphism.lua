-- OOP: Polymorphism in Lua

-- Polymorphism: Different objects responding to the same method call

-- Base class
local Shape = {}
Shape.__index = Shape

function Shape.new()
    local self = setmetatable({}, Shape)
    return self
end

function Shape:area()
    error("Must implement area() method")
end

function Shape:draw()
    print("Drawing a shape")
end

-- Circle
local Circle = {}
Circle.__index = Circle
setmetatable(Circle, {__index = Shape})

function Circle.new(radius)
    local self = setmetatable({}, Circle)
    self.radius = radius
    return self
end

function Circle:area()
    return math.pi * self.radius ^ 2
end

function Circle:draw()
    print("Drawing a circle with radius " .. self.radius)
end

-- Rectangle
local Rectangle = {}
Rectangle.__index = Rectangle
setmetatable(Rectangle, {__index = Shape})

function Rectangle.new(width, height)
    local self = setmetatable({}, Rectangle)
    self.width = width
    self.height = height
    return self
end

function Rectangle:area()
    return self.width * self.height
end

function Rectangle:draw()
    print("Drawing a " .. self.width .. "x" .. self.height .. " rectangle")
end

-- Triangle
local Triangle = {}
Triangle.__index = Triangle
setmetatable(Triangle, {__index = Shape})

function Triangle.new(base, height)
    local self = setmetatable({}, Triangle)
    self.base = base
    self.height = height
    return self
end

function Triangle:area()
    return 0.5 * self.base * self.height
end

function Triangle:draw()
    print("Drawing a triangle")
end

-- Polymorphic function
local function printShapeInfo(shape)
    shape:draw()
    print("Area:", shape:area())
    print()
end

-- Create different shapes
local shapes = {
    Circle.new(5),
    Rectangle.new(4, 6),
    Triangle.new(3, 4),
    Circle.new(3)
}

-- Call same method on different objects
print("=== Polymorphism Demo ===")
for i, shape in ipairs(shapes) do
    printShapeInfo(shape)
end

-- Animal polymorphism
local Animal = {}
Animal.__index = Animal

function Animal:makeSound()
    print("Some generic animal sound")
end

local Dog = {}
Dog.__index = Dog
setmetatable(Dog, {__index = Animal})

function Dog.new(name)
    local self = setmetatable({}, Dog)
    self.name = name
    return self
end

function Dog:makeSound()
    print(self.name .. " says Woof!")
end

local Cat = {}
Cat.__index = Cat
setmetatable(Cat, {__index = Animal})

function Cat.new(name)
    local self = setmetatable({}, Cat)
    self.name = name
    return self
end

function Cat:makeSound()
    print(self.name .. " says Meow!")
end

local Cow = {}
Cow.__index = Cow
setmetatable(Cow, {__index = Animal})

function Cow.new(name)
    local self = setmetatable({}, Cow)
    self.name = name
    return self
end

function Cow:makeSound()
    print(self.name .. " says Moo!")
end

-- Polymorphic behavior
local animals = {
    Dog.new("Buddy"),
    Cat.new("Whiskers"),
    Cow.new("Bessie"),
    Dog.new("Max")
}

print("=== Animal Sounds ===")
for i, animal in ipairs(animals) do
    animal:makeSound()
end

-- Payment method polymorphism
local Payment = {}
Payment.__index = Payment

function Payment:process(amount)
    error("Must implement process() method")
end

local CreditCard = {}
CreditCard.__index = CreditCard
setmetatable(CreditCard, {__index = Payment})

function CreditCard.new(cardNumber)
    local self = setmetatable({}, CreditCard)
    self.cardNumber = cardNumber
    return self
end

function CreditCard:process(amount)
    print("Processing $" .. amount .. " via Credit Card ending in " .. 
          string.sub(self.cardNumber, -4))
end

local PayPal = {}
PayPal.__index = PayPal
setmetatable(PayPal, {__index = Payment})

function PayPal.new(email)
    local self = setmetatable({}, PayPal)
    self.email = email
    return self
end

function PayPal:process(amount)
    print("Processing $" .. amount .. " via PayPal (" .. self.email .. ")")
end

local Cash = {}
Cash.__index = Cash
setmetatable(Cash, {__index = Payment})

function Cash.new()
    return setmetatable({}, Cash)
end

function Cash:process(amount)
    print("Processing $" .. amount .. " in cash")
end

-- Process payments polymorphically
local payments = {
    CreditCard.new("1234567890123456"),
    PayPal.new("user@example.com"),
    Cash.new()
}

print("\n=== Processing Payments ===")
for i, payment in ipairs(payments) do
    payment:process(100)
end
