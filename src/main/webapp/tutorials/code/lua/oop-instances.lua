-- OOP: Creating and Using Instances

-- Define a class
local Car = {}
Car.__index = Car

-- Constructor
function Car.new(make, model, year)
    local self = setmetatable({}, Car)
    self.make = make
    self.model = model
    self.year = year
    self.mileage = 0
    return self
end

-- Instance methods
function Car:drive(miles)
    self.mileage = self.mileage + miles
    print(self.make .. " " .. self.model .. " drove " .. miles .. " miles")
end

function Car:getInfo()
    return string.format("%d %s %s with %d miles", 
        self.year, self.make, self.model, self.mileage)
end

-- Create instances
local car1 = Car.new("Toyota", "Camry", 2020)
local car2 = Car.new("Honda", "Civic", 2021)

print(car1:getInfo())
print(car2:getInfo())

car1:drive(100)
car2:drive(50)

print(car1:getInfo())
print(car2:getInfo())

-- Each instance has its own data
print("\ncar1 mileage:", car1.mileage)
print("car2 mileage:", car2.mileage)

-- Student class example
local Student = {}
Student.__index = Student

function Student.new(name, grade)
    local self = setmetatable({}, Student)
    self.name = name
    self.grade = grade
    self.courses = {}
    return self
end

function Student:addCourse(course)
    table.insert(self.courses, course)
end

function Student:getCourses()
    return table.concat(self.courses, ", ")
end

function Student:promote()
    self.grade = self.grade + 1
end

local student1 = Student.new("Alice", 9)
student1:addCourse("Math")
student1:addCourse("Science")
student1:addCourse("English")

print("\nStudent:", student1.name)
print("Grade:", student1.grade)
print("Courses:", student1:getCourses())

student1:promote()
print("After promotion, grade:", student1.grade)

-- Multiple instances
local students = {
    Student.new("Bob", 10),
    Student.new("Charlie", 10),
    Student.new("David", 11)
}

for i, student in ipairs(students) do
    print(i .. ".", student.name, "- Grade", student.grade)
end

-- Instance with validation
local Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle.new(width, height)
    if width <= 0 or height <= 0 then
        error("Width and height must be positive")
    end
    
    local self = setmetatable({}, Rectangle)
    self.width = width
    self.height = height
    return self
end

function Rectangle:area()
    return self.width * self.height
end

function Rectangle:perimeter()
    return 2 * (self.width + self.height)
end

local rect = Rectangle.new(5, 3)
print("\nRectangle:", rect.width, "x", rect.height)
print("Area:", rect:area())
print("Perimeter:", rect:perimeter())
