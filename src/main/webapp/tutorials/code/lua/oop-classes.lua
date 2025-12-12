-- OOP: Creating Classes in Lua

-- Classes in Lua are created using tables and metatables

-- Basic class definition
local Animal = {}
Animal.__index = Animal

-- Constructor
function Animal.new(name, sound)
    local self = setmetatable({}, Animal)
    self.name = name
    self.sound = sound
    return self
end

-- Instance method
function Animal:makeSound()
    print(self.name .. " says " .. self.sound)
end

function Animal:describe()
    print("This is " .. self.name)
end

-- Create instances
local cat = Animal.new("Whiskers", "Meow")
local dog = Animal.new("Buddy", "Woof")

cat:makeSound()
dog:makeSound()

-- Another class example
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

function Person:birthday()
    self.age = self.age + 1
    print(self.name .. " is now " .. self.age)
end

local alice = Person.new("Alice", 25)
alice:introduce()
alice:birthday()

-- Class with private-like variables
local function BankAccount(initialBalance)
    local balance = initialBalance  -- "private"
    
    local account = {}
    
    function account:deposit(amount)
        balance = balance + amount
        return balance
    end
    
    function account:withdraw(amount)
        if amount > balance then
            print("Insufficient funds!")
            return balance
        end
        balance = balance - amount
        return balance
    end
    
    function account:getBalance()
        return balance
    end
    
    return account
end

local myAccount = BankAccount(1000)
print("Balance:", myAccount:getBalance())
myAccount:deposit(500)
print("After deposit:", myAccount:getBalance())
myAccount:withdraw(200)
print("After withdraw:", myAccount:getBalance())

-- Class with class methods (static methods)
local MathUtils = {}

function MathUtils.add(a, b)
    return a + b
end

function MathUtils.multiply(a, b)
    return a * b
end

print("5 + 3 =", MathUtils.add(5, 3))
print("5 * 3 =", MathUtils.multiply(5, 3))
