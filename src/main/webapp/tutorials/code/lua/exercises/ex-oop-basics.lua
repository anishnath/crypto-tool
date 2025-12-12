-- Exercise: OOP Basics
-- TODO: Complete the following exercises

-- 1. Create a Book class with title, author, and pages
local Book = {}
Book.__index = Book

function Book.new(title, author, pages)
    -- your code here
end

function Book:getInfo()
    -- your code here
    -- return a string with book information
end

-- local book = Book.new("1984", "George Orwell", 328)
-- print(book:getInfo())

-- 2. Create a Circle class with radius
local Circle = {}
Circle.__index = Circle

function Circle.new(radius)
    -- your code here
end

function Circle:area()
    -- your code here
    -- return area (π * r²)
end

function Circle:circumference()
    -- your code here
    -- return circumference (2 * π * r)
end

-- local circle = Circle.new(5)
-- print("Area:", circle:area())
-- print("Circumference:", circle:circumference())

-- 3. Create a BankAccount class
local BankAccount = {}
BankAccount.__index = BankAccount

function BankAccount.new(owner, initialBalance)
    -- your code here
    -- initialize owner and balance
end

function BankAccount:deposit(amount)
    -- your code here
    -- add amount to balance
end

function BankAccount:withdraw(amount)
    -- your code here
    -- subtract amount from balance if sufficient funds
    -- return true/false for success
end

function BankAccount:getBalance()
    -- your code here
end

-- local account = BankAccount.new("Alice", 1000)
-- account:deposit(500)
-- account:withdraw(200)
-- print("Balance:", account:getBalance())

-- 4. Create a Student class with grades
local Student = {}
Student.__index = Student

function Student.new(name)
    -- your code here
    -- initialize name and empty grades table
end

function Student:addGrade(subject, grade)
    -- your code here
    -- add grade for subject
end

function Student:getAverage()
    -- your code here
    -- calculate and return average grade
end

-- local student = Student.new("Bob")
-- student:addGrade("Math", 85)
-- student:addGrade("Science", 90)
-- student:addGrade("English", 88)
-- print("Average:", student:getAverage())

-- 5. Create a Counter class with class variable
local Counter = {}
Counter.__index = Counter
Counter.totalInstances = 0

function Counter.new()
    -- your code here
    -- increment totalInstances
    -- initialize count to 0
end

function Counter:increment()
    -- your code here
end

function Counter:getCount()
    -- your code here
end

function Counter.getTotalInstances()
    -- your code here
end

-- local c1 = Counter.new()
-- local c2 = Counter.new()
-- c1:increment()
-- c1:increment()
-- c2:increment()
-- print("c1 count:", c1:getCount())
-- print("c2 count:", c2:getCount())
-- print("Total instances:", Counter.getTotalInstances())
