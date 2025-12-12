-- String Library Functions

local text = "Hello, Lua Programming!"

-- string.upper() and string.lower()
print("=== Case Conversion ===")
print("Upper:", string.upper(text))
print("Lower:", string.lower(text))

-- string.len() - length
print("\n=== Length ===")
print("Length:", string.len(text))
print("Using #:", #text)

-- string.sub() - substring
print("\n=== Substring ===")
print("First 5 chars:", string.sub(text, 1, 5))
print("From 8 onwards:", string.sub(text, 8))
print("Last 12 chars:", string.sub(text, -12))

-- string.find() - search
print("\n=== Find ===")
local start, finish = string.find(text, "Lua")
print("'Lua' found at:", start, finish)

-- string.gsub() - replace
print("\n=== Replace ===")
local replaced = string.gsub(text, "Lua", "Python")
print("Replaced:", replaced)

-- string.rep() - repeat
print("\n=== Repeat ===")
print(string.rep("Ha", 5))
print(string.rep("-", 20))

-- string.reverse() - reverse
print("\n=== Reverse ===")
print("Reversed:", string.reverse("Lua"))

-- string.format() - formatting
print("\n=== Format ===")
local name = "Alice"
local age = 25
print(string.format("Name: %s, Age: %d", name, age))
print(string.format("Pi: %.2f", 3.14159))

-- Method syntax (syntactic sugar)
print("\n=== Method Syntax ===")
print("Hello":upper())
print("WORLD":lower())
print("Lua":rep(3))
