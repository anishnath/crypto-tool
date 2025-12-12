-- String Basics in Lua

-- Creating strings
local str1 = "Hello"
local str2 = 'World'
local str3 = [[Multi-line
string using
double brackets]]

print("String 1:", str1)
print("String 2:", str2)
print("String 3:", str3)

-- String concatenation with ..
local greeting = str1 .. " " .. str2
print("\nConcatenated:", greeting)

-- String length with #
print("\nLength of 'Hello':", #str1)
print("Length of greeting:", #greeting)

-- Escape sequences
local escaped = "Line 1\nLine 2\tTabbed"
print("\nEscape sequences:")
print(escaped)

-- String with quotes
local quote1 = "He said, \"Hello!\""
local quote2 = 'It\'s a beautiful day'
print("\nQuotes:")
print(quote1)
print(quote2)

-- Number to string conversion
local num = 42
local numStr = tostring(num)
print("\nNumber to string:", numStr, type(numStr))

-- String to number conversion
local strNum = "123"
local converted = tonumber(strNum)
print("String to number:", converted, type(converted))
