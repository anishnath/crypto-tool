-- Function Factories with Closures

-- Simple factory - creating specialized functions
local function createAdder(n)
    return function(x)
        return x + n
    end
end

local add5 = createAdder(5)
local add10 = createAdder(10)

print("7 + 5 =", add5(7))
print("7 + 10 =", add10(7))

-- Factory with configuration
local function createGreeter(greeting)
    return function(name)
        return greeting .. ", " .. name .. "!"
    end
end

local sayHello = createGreeter("Hello")
local sayHi = createGreeter("Hi")
local sayHola = createGreeter("Hola")

print(sayHello("Alice"))
print(sayHi("Bob"))
print(sayHola("Carlos"))

-- Factory creating objects with methods
local function createPerson(name, age)
    local person = {}
    
    person.getName = function()
        return name
    end
    
    person.getAge = function()
        return age
    end
    
    person.haveBirthday = function()
        age = age + 1
        return age
    end
    
    person.introduce = function()
        return "Hi, I'm " .. name .. " and I'm " .. age .. " years old"
    end
    
    return person
end

local alice = createPerson("Alice", 25)
print(alice.introduce())
alice.haveBirthday()
print(alice.introduce())

-- Factory for validators
local function createRangeValidator(min, max)
    return function(value)
        return value >= min and value <= max
    end
end

local isValidAge = createRangeValidator(0, 120)
local isValidPercent = createRangeValidator(0, 100)

print("Is 25 valid age?", isValidAge(25))
print("Is 150 valid age?", isValidAge(150))
print("Is 75 valid percent?", isValidPercent(75))

-- Factory for formatters
local function createFormatter(prefix, suffix)
    return function(text)
        return prefix .. text .. suffix
    end
end

local bold = createFormatter("**", "**")
local italic = createFormatter("_", "_")
local code = createFormatter("`", "`")

print(bold("Important"))
print(italic("Emphasis"))
print(code("console.log()"))

-- Chaining factories
local function createMultiplier(factor)
    return function(x)
        return x * factor
    end
end

local double = createMultiplier(2)
local triple = createMultiplier(3)
local sextuple = function(x)
    return triple(double(x))
end

print("6 * 5 =", sextuple(5))
