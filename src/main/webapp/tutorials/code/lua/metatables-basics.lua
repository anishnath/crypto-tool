-- Metatables Basics in Lua

-- Metatables allow you to change the behavior of tables

-- Creating a simple metatable
print("=== Basic Metatable ===")
local t = {value = 10}
local mt = {
    __index = function(table, key)
        return "Key '" .. key .. "' not found"
    end
}

setmetatable(t, mt)
print("t.value:", t.value)        -- 10 (exists)
print("t.missing:", t.missing)    -- "Key 'missing' not found"

-- __index with table
print("\n=== __index with Table ===")
local defaults = {x = 0, y = 0, z = 0}
local point = {x = 10}

setmetatable(point, {__index = defaults})
print("point.x:", point.x)  -- 10 (from point)
print("point.y:", point.y)  -- 0 (from defaults)
print("point.z:", point.z)  -- 0 (from defaults)

-- __newindex (intercept assignments)
print("\n=== __newindex ===")
local readonly = {}
local data = {value = 42}

setmetatable(readonly, {
    __index = data,
    __newindex = function(t, k, v)
        error("Table is read-only!")
    end
})

print("readonly.value:", readonly.value)  -- 42
-- readonly.value = 100  -- Would error!

-- __tostring (custom string representation)
print("\n=== __tostring ===")
local person = {name = "Alice", age = 25}

setmetatable(person, {
    __tostring = function(t)
        return t.name .. " (" .. t.age .. " years old)"
    end
})

print("Person:", person)  -- Uses __tostring

-- __call (make table callable like a function)
print("\n=== __call ===")
local counter = {count = 0}

setmetatable(counter, {
    __call = function(t)
        t.count = t.count + 1
        return t.count
    end
})

print("Call 1:", counter())  -- 1
print("Call 2:", counter())  -- 2
print("Call 3:", counter())  -- 3

-- __len (custom length operator)
print("\n=== __len ===")
local customArray = {items = {10, 20, 30, 40, 50}}

setmetatable(customArray, {
    __len = function(t)
        return #t.items
    end
})

print("Length:", #customArray)  -- 5

-- Inheritance with metatables
print("\n=== Inheritance ===")
local Animal = {sound = "..."}

function Animal:makeSound()
    print(self.sound)
end

local Dog = {sound = "Woof!"}
setmetatable(Dog, {__index = Animal})

Dog:makeSound()  -- "Woof!"

-- Creating instances
local myDog = {name = "Buddy"}
setmetatable(myDog, {__index = Dog})

print("My dog:", myDog.name)
myDog:makeSound()  -- "Woof!" (inherited)

-- Protecting metatables
print("\n=== Protected Metatable ===")
local protected = {value = 100}
local mt = {
    __metatable = "This metatable is protected!",
    __index = function(t, k)
        return "Protected"
    end
}

setmetatable(protected, mt)
print("Get metatable:", getmetatable(protected))  -- "This metatable is protected!"
-- setmetatable(protected, {})  -- Would error!

-- Checking for metatables
print("\n=== Checking Metatables ===")
local normal = {a = 1}
local withMT = {b = 2}
setmetatable(withMT, {})

print("normal has metatable:", getmetatable(normal) ~= nil)
print("withMT has metatable:", getmetatable(withMT) ~= nil)

-- Rawget and rawset (bypass metatables)
print("\n=== Raw Access ===")
local tracked = {}
local mt = {
    __index = function(t, k)
        print("Accessing:", k)
        return rawget(t, k)
    end,
    __newindex = function(t, k, v)
        print("Setting:", k, "=", v)
        rawset(t, k, v)
    end
}

setmetatable(tracked, mt)
tracked.value = 42  -- Triggers __newindex
print(tracked.value)  -- Triggers __index

-- Using rawget/rawset to avoid metamethods
rawset(tracked, "direct", 100)
print("Direct:", rawget(tracked, "direct"))
