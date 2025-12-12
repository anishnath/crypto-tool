-- Lua has 8 basic types. Let's explore them!

-- 1. nil (represents "no value")
local nothing = nil
print("1. nil:", nothing)
print("   Type:", type(nothing))

-- 2. boolean (true or false)
local isLuaFun = true
local isBoring = false
print("\n2. boolean:", isLuaFun, isBoring)
print("   Type:", type(isLuaFun))

-- 3. number (integers and floats)
local age = 25
local pi = 3.14159
print("\n3. number:", age, pi)
print("   Type:", type(age), type(pi))

-- 4. string (text)
local greeting = "Hello, Lua!"
local name = 'Alice'
print("\n4. string:", greeting, name)
print("   Type:", type(greeting))

-- 5. function (first-class values!)
local function sayHello()
    return "Hello from a function!"
end
print("\n5. function:", sayHello())
print("   Type:", type(sayHello))

-- 6. table (Lua's main data structure)
local person = {name = "Bob", age = 30}
print("\n6. table:", person)
print("   Type:", type(person))
print("   person.name =", person.name)

-- 7. userdata (C data, advanced topic)
-- We'll skip this for now

-- 8. thread (for coroutines, advanced topic)
-- We'll cover this in the Advanced Topics module

print("\n✨ Lua's dynamic typing means variables can change types!")
local x = 42
print("x is a number:", x, type(x))

x = "now a string"
print("x is now a string:", x, type(x))

x = true
print("x is now a boolean:", x, type(x))
