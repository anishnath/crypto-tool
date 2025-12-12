-- Object-Oriented Programming with Metatables

-- Basic class
print("=== Basic Class ===")

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

local cat = Animal.new("Whiskers", "Meow")
cat:makeSound()
cat:describe()

-- Inheritance
print("\n=== Inheritance ===")

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

local dog = Dog.new("Buddy", "Golden Retriever")
dog:makeSound()      -- Inherited from Animal
dog:describe()       -- Inherited from Animal
dog:fetch()          -- Dog's own method
print("Breed:", dog.breed)

-- Encapsulation (private members)
print("\n=== Encapsulation ===")

local function BankAccount(initialBalance)
    -- Private variables
    local balance = initialBalance
    local transactions = {}
    
    -- Private function
    local function recordTransaction(type, amount)
        table.insert(transactions, {
            type = type,
            amount = amount,
            balance = balance
        })
    end
    
    -- Public interface
    local account = {}
    
    function account:deposit(amount)
        if amount <= 0 then
            return false, "Amount must be positive"
        end
        balance = balance + amount
        recordTransaction("deposit", amount)
        return true, balance
    end
    
    function account:withdraw(amount)
        if amount > balance then
            return false, "Insufficient funds"
        end
        balance = balance - amount
        recordTransaction("withdraw", amount)
        return true, balance
    end
    
    function account:getBalance()
        return balance
    end
    
    function account:getHistory()
        return transactions
    end
    
    return account
end

local myAccount = BankAccount(1000)
print("Balance:", myAccount:getBalance())
myAccount:deposit(500)
print("After deposit:", myAccount:getBalance())
myAccount:withdraw(200)
print("After withdraw:", myAccount:getBalance())

-- Polymorphism
print("\n=== Polymorphism ===")

local Shape = {}
Shape.__index = Shape

function Shape.new()
    return setmetatable({}, Shape)
end

function Shape:area()
    error("Must implement area() method")
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

local shapes = {
    Circle.new(5),
    Rectangle.new(4, 6),
    Circle.new(3)
}

for i, shape in ipairs(shapes) do
    print("Shape " .. i .. " area:", shape:area())
end

-- Class with static methods
print("\n=== Static Methods ===")

local MathUtils = {}

function MathUtils.add(a, b)
    return a + b
end

function MathUtils.multiply(a, b)
    return a * b
end

print("5 + 3 =", MathUtils.add(5, 3))
print("5 * 3 =", MathUtils.multiply(5, 3))

-- Constructor with validation
print("\n=== Constructor Validation ===")

local Person = {}
Person.__index = Person

function Person.new(name, age)
    if type(name) ~= "string" or name == "" then
        error("Name must be a non-empty string")
    end
    if type(age) ~= "number" or age < 0 then
        error("Age must be a positive number")
    end
    
    local self = setmetatable({}, Person)
    self.name = name
    self.age = age
    return self
end

function Person:birthday()
    self.age = self.age + 1
end

function Person:introduce()
    return "Hi, I'm " .. self.name .. " and I'm " .. self.age
end

local alice = Person.new("Alice", 25)
print(alice:introduce())
alice:birthday()
print(alice:introduce())

-- Method chaining
print("\n=== Method Chaining ===")

local Builder = {}
Builder.__index = Builder

function Builder.new()
    return setmetatable({value = ""}, Builder)
end

function Builder:append(str)
    self.value = self.value .. str
    return self  -- Return self for chaining
end

function Builder:upper()
    self.value = string.upper(self.value)
    return self
end

function Builder:build()
    return self.value
end

local result = Builder.new()
    :append("hello")
    :append(" ")
    :append("world")
    :upper()
    :build()

print("Result:", result)
