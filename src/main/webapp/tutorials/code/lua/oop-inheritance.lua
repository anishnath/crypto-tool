-- OOP: Inheritance in Lua

-- Base class
local Animal = {}
Animal.__index = Animal

function Animal.new(name, sound)
    local self = setmetatable({}, Animal)
    self.name = name
    self.sound = sound
    return self
end

function Animal:makeSound()
    print(self.name .. " says " .. self.sound)
end

function Animal:describe()
    print("This is " .. self.name)
end

-- Derived class: Dog
local Dog = {}
Dog.__index = Dog
setmetatable(Dog, {__index = Animal})  -- Dog inherits from Animal

function Dog.new(name, breed)
    local self = setmetatable({}, Dog)
    self.name = name
    self.sound = "Woof"
    self.breed = breed
    return self
end

function Dog:fetch()
    print(self.name .. " is fetching!")
end

-- Derived class: Cat
local Cat = {}
Cat.__index = Cat
setmetatable(Cat, {__index = Animal})

function Cat.new(name, color)
    local self = setmetatable({}, Cat)
    self.name = name
    self.sound = "Meow"
    self.color = color
    return self
end

function Cat:scratch()
    print(self.name .. " is scratching!")
end

-- Create instances
local dog = Dog.new("Buddy", "Golden Retriever")
local cat = Cat.new("Whiskers", "Orange")

-- Inherited methods
dog:makeSound()  -- From Animal
dog:describe()   -- From Animal
dog:fetch()      -- Dog's own method

cat:makeSound()  -- From Animal
cat:describe()   -- From Animal
cat:scratch()    -- Cat's own method

-- Shape hierarchy
local Shape = {}
Shape.__index = Shape

function Shape.new()
    local self = setmetatable({}, Shape)
    return self
end

function Shape:area()
    error("Must implement area() method")
end

-- Rectangle inherits from Shape
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

-- Circle inherits from Shape
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

local rect = Rectangle.new(5, 3)
local circle = Circle.new(4)

print("\nShapes:")
print("Rectangle area:", rect:area())
print("Circle area:", circle:area())

-- Vehicle hierarchy
local Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle.new(make, model)
    local self = setmetatable({}, Vehicle)
    self.make = make
    self.model = model
    self.speed = 0
    return self
end

function Vehicle:accelerate(amount)
    self.speed = self.speed + amount
    print(self.make .. " " .. self.model .. " speed: " .. self.speed)
end

function Vehicle:brake(amount)
    self.speed = math.max(0, self.speed - amount)
    print(self.make .. " " .. self.model .. " speed: " .. self.speed)
end

-- Car inherits from Vehicle
local Car = {}
Car.__index = Car
setmetatable(Car, {__index = Vehicle})

function Car.new(make, model, doors)
    local self = setmetatable({}, Car)
    self.make = make
    self.model = model
    self.speed = 0
    self.doors = doors
    return self
end

function Car:honk()
    print("Beep beep!")
end

local car = Car.new("Toyota", "Camry", 4)
car:accelerate(30)  -- Inherited
car:accelerate(20)  -- Inherited
car:honk()          -- Car's own method
car:brake(25)       -- Inherited
