-- OOP: Calling Parent (Super) Methods

-- Base class
local Animal = {}
Animal.__index = Animal

function Animal.new(name)
    local self = setmetatable({}, Animal)
    self.name = name
    return self
end

function Animal:eat(food)
    print(self.name .. " is eating " .. food)
end

function Animal:sleep()
    print(self.name .. " is sleeping")
end

-- Derived class that calls parent methods
local Dog = {}
Dog.__index = Dog
setmetatable(Dog, {__index = Animal})

function Dog.new(name, breed)
    -- Call parent constructor
    local self = Animal.new(name)
    setmetatable(self, Dog)
    self.breed = breed
    return self
end

-- Override parent method but call it
function Dog:eat(food)
    print(self.name .. " (a " .. self.breed .. ") is excited!")
    Animal.eat(self, food)  -- Call parent method
    print("Wag wag!")
end

function Dog:bark()
    print(self.name .. " says Woof!")
end

local dog = Dog.new("Buddy", "Golden Retriever")
dog:eat("kibble")
dog:sleep()  -- Inherited, not overridden
dog:bark()

-- Person and Employee hierarchy
local Person = {}
Person.__index = Person

function Person.new(name, age)
    local self = setmetatable({}, Person)
    self.name = name
    self.age = age
    return self
end

function Person:introduce()
    print("Hi, I'm " .. self.name .. " and I'm " .. self.age .. " years old")
end

-- Employee extends Person
local Employee = {}
Employee.__index = Employee
setmetatable(Employee, {__index = Person})

function Employee.new(name, age, jobTitle, salary)
    local self = Person.new(name, age)
    setmetatable(self, Employee)
    self.jobTitle = jobTitle
    self.salary = salary
    return self
end

-- Override and extend parent method
function Employee:introduce()
    Person.introduce(self)  -- Call parent method
    print("I work as a " .. self.jobTitle)
end

function Employee:work()
    print(self.name .. " is working as a " .. self.jobTitle)
end

local emp = Employee.new("Alice", 30, "Software Engineer", 80000)
emp:introduce()
emp:work()

-- Shape hierarchy with super calls
local Shape = {}
Shape.__index = Shape

function Shape.new()
    local self = setmetatable({}, Shape)
    self.color = "white"
    return self
end

function Shape:setColor(color)
    self.color = color
    print("Shape color set to " .. color)
end

function Shape:describe()
    print("This is a " .. self.color .. " shape")
end

-- Rectangle extends Shape
local Rectangle = {}
Rectangle.__index = Rectangle
setmetatable(Rectangle, {__index = Shape})

function Rectangle.new(width, height)
    local self = Shape.new()
    setmetatable(self, Rectangle)
    self.width = width
    self.height = height
    return self
end

function Rectangle:setColor(color)
    Shape.setColor(self, color)  -- Call parent method
    print("Rectangle is now " .. color)
end

function Rectangle:describe()
    Shape.describe(self)  -- Call parent method
    print("It's a " .. self.width .. "x" .. self.height .. " rectangle")
end

local rect = Rectangle.new(5, 3)
rect:setColor("blue")
rect:describe()

-- Method chaining with parent calls
local Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle.new()
    local self = setmetatable({}, Vehicle)
    self.speed = 0
    return self
end

function Vehicle:accelerate(amount)
    self.speed = self.speed + amount
    print("Speed: " .. self.speed)
    return self
end

local Car = {}
Car.__index = Car
setmetatable(Car, {__index = Vehicle})

function Car.new(make)
    local self = Vehicle.new()
    setmetatable(self, Car)
    self.make = make
    return self
end

function Car:accelerate(amount)
    print(self.make .. " accelerating...")
    Vehicle.accelerate(self, amount)  -- Call parent
    return self
end

function Car:honk()
    print(self.make .. " says beep!")
    return self
end

local car = Car.new("Toyota")
car:accelerate(30):honk():accelerate(20)
