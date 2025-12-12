-- Exercise: Inheritance
-- TODO: Complete the following exercises

-- 1. Create a Vehicle base class and Car derived class
local Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle.new(make, model)
    -- your code here
end

function Vehicle:start()
    -- your code here
end

local Car = {}
Car.__index = Car
setmetatable(Car, {__index = Vehicle})

function Car.new(make, model, doors)
    -- your code here
    -- call parent constructor
end

function Car:honk()
    -- your code here
end

-- local car = Car.new("Toyota", "Camry", 4)
-- car:start()  -- Should work (inherited)
-- car:honk()   -- Should work (own method)

-- 2. Create Shape, Rectangle, and Circle with area() method
local Shape = {}
Shape.__index = Shape

function Shape.new()
    -- your code here
end

function Shape:area()
    -- your code here
    -- should error or return 0
end

local Rectangle = {}
Rectangle.__index = Rectangle
setmetatable(Rectangle, {__index = Shape})

function Rectangle.new(width, height)
    -- your code here
end

function Rectangle:area()
    -- your code here
end

local Circle = {}
Circle.__index = Circle
setmetatable(Circle, {__index = Shape})

function Circle.new(radius)
    -- your code here
end

function Circle:area()
    -- your code here
end

-- local rect = Rectangle.new(5, 3)
-- local circle = Circle.new(4)
-- print("Rectangle area:", rect:area())
-- print("Circle area:", circle:area())

-- 3. Create Employee that extends Person
local Person = {}
Person.__index = Person

function Person.new(name, age)
    -- your code here
end

function Person:introduce()
    -- your code here
end

local Employee = {}
Employee.__index = Employee
setmetatable(Employee, {__index = Person})

function Employee.new(name, age, jobTitle)
    -- your code here
    -- call parent constructor
end

function Employee:introduce()
    -- your code here
    -- call parent introduce, then add job info
end

-- local emp = Employee.new("Alice", 30, "Developer")
-- emp:introduce()

-- 4. Create polymorphic animals
local Animal = {}
Animal.__index = Animal

function Animal:makeSound()
    -- your code here
end

local Dog = {}
Dog.__index = Dog
setmetatable(Dog, {__index = Animal})

function Dog.new(name)
    -- your code here
end

function Dog:makeSound()
    -- your code here (Woof!)
end

local Cat = {}
Cat.__index = Cat
setmetatable(Cat, {__index = Animal})

function Cat.new(name)
    -- your code here
end

function Cat:makeSound()
    -- your code here (Meow!)
end

-- local animals = {Dog.new("Buddy"), Cat.new("Whiskers")}
-- for i, animal in ipairs(animals) do
--     animal:makeSound()
-- end
