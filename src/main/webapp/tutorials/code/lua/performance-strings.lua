-- String Performance Optimization in Lua

-- Strings in Lua are immutable
-- String operations can be expensive if not done carefully

print("=== String Concatenation ===")

-- Slow: Repeated concatenation (creates many intermediate strings)
local function slowConcat()
    local s = ""
    for i = 1, 1000 do
        s = s .. tostring(i)
    end
    return s
end

-- Fast: table.concat
local function fastConcat()
    local t = {}
    for i = 1, 1000 do
        t[i] = tostring(i)
    end
    return table.concat(t)
end

local start = os.clock()
slowConcat()
print("Slow concat:", os.clock() - start)

start = os.clock()
fastConcat()
print("Fast concat:", os.clock() - start)

print("\n=== String Building ===")

-- Slow: Multiple concatenations
local function slowBuild()
    local s = "Hello"
    s = s .. " "
    s = s .. "World"
    s = s .. "!"
    return s
end

-- Faster: Single concatenation
local function fastBuild()
    return "Hello" .. " " .. "World" .. "!"
end

-- Best: table.concat for many parts
local function bestBuild()
    return table.concat({"Hello", " ", "World", "!"})
end

print("\n=== String Formatting ===")

-- Using string.format
local name = "Alice"
local age = 25

-- Good for complex formatting
local formatted = string.format("Name: %s, Age: %d", name, age)
print(formatted)

-- Simple concatenation is fine for simple cases
local simple = "Name: " .. name .. ", Age: " .. age
print(simple)

print("\n=== String Matching ===")

local text = "The quick brown fox jumps over the lazy dog"

-- Cache pattern if used multiple times
local pattern = "%w+"
local function findWords(str)
    local words = {}
    for word in str:gmatch(pattern) do
        table.insert(words, word)
    end
    return words
end

local words = findWords(text)
print("Found", #words, "words")

print("\n=== String Interning ===")

-- Lua automatically interns strings
-- Same string literal uses same memory
local s1 = "hello"
local s2 = "hello"
print("Same string:", s1 == s2)  -- true, same object

print("\n=== Avoid Unnecessary Conversions ===")

-- Slow: Converting back and forth
local function slowConversion()
    local n = 42
    for i = 1, 10000 do
        local s = tostring(n)
        local back = tonumber(s)
    end
end

-- Fast: Keep in original type
local function fastNoConversion()
    local n = 42
    for i = 1, 10000 do
        -- Use n directly
    end
end

start = os.clock()
slowConversion()
print("With conversion:", os.clock() - start)

start = os.clock()
fastNoConversion()
print("No conversion:", os.clock() - start)

print("\n=== String Buffer Pattern ===")

local function createStringBuffer()
    local buffer = {}
    
    return {
        append = function(str)
            table.insert(buffer, str)
        end,
        
        toString = function()
            return table.concat(buffer)
        end,
        
        clear = function()
            buffer = {}
        end
    }
end

local buf = createStringBuffer()
buf.append("Hello")
buf.append(" ")
buf.append("World")
print("Buffer result:", buf.toString())

print("\n=== Substring Operations ===")

local longString = string.rep("a", 10000)

-- string.sub is efficient (doesn't copy)
local function useSub()
    for i = 1, 1000 do
        local sub = string.sub(longString, 1, 10)
    end
end

start = os.clock()
useSub()
print("string.sub:", os.clock() - start)

print("\n=== String Comparison ===")

-- String comparison is fast (compares pointers first)
local str1 = "hello"
local str2 = "hello"
local str3 = "world"

print("str1 == str2:", str1 == str2)  -- Fast
print("str1 == str3:", str1 == str3)  -- Fast

print("\n=== Pattern Matching Optimization ===")

-- Cache compiled patterns when possible
local emailPattern = "[%w%.]+@[%w%.]+%.%w+"

local function validateEmail(email)
    return email:match(emailPattern) ~= nil
end

print("Valid email:", validateEmail("test@example.com"))

print("\n=== String Replacement ===")

-- string.gsub is efficient
local text = "Hello World Hello Lua"
local replaced = text:gsub("Hello", "Hi")
print("Replaced:", replaced)

print("\n=== Avoid String in Loops ===")

-- Slow: String operations in tight loop
local function slowLoop()
    for i = 1, 10000 do
        local s = "prefix" .. i .. "suffix"
    end
end

-- Faster: Minimize string operations
local function fastLoop()
    local prefix = "prefix"
    local suffix = "suffix"
    for i = 1, 10000 do
        local s = prefix .. i .. suffix
    end
end

start = os.clock()
slowLoop()
print("Slow loop:", os.clock() - start)

start = os.clock()
fastLoop()
print("Fast loop:", os.clock() - start)

print("\n=== String Length ===")

-- # operator is O(1) for strings
local str = "Hello World"
print("Length:", #str)  -- Fast

print("\n=== Best Practices ===")
print("1. Use table.concat for building long strings")
print("2. Cache patterns for repeated matching")
print("3. Avoid unnecessary type conversions")
print("4. Use string buffer pattern for incremental building")
print("5. Minimize string operations in tight loops")
print("6. Leverage string interning")
