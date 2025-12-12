-- Exercise: Functions
-- TODO: Complete the following exercises

-- 1. Create a function that calculates the area of a rectangle
local function calculateRectangleArea(length, width)
    -- your code here
end

print("Rectangle area:", calculateRectangleArea(5, 3))

-- 2. Create a function that checks if a number is even
local function isEven(number)
    -- your code here (hint: use % operator)
end

print("Is 4 even?", isEven(4))
print("Is 7 even?", isEven(7))

-- 3. Create a function that returns both sum and product of two numbers
local function sumAndProduct(a, b)
    -- your code here (return two values)
end

local s, p = sumAndProduct(5, 3)
print("Sum:", s, "Product:", p)

-- 4. Create a function that finds the maximum of three numbers
local function findMax(a, b, c)
    -- your code here
end

print("Max of 10, 25, 15:", findMax(10, 25, 15))

-- 5. Create a function that converts Celsius to Fahrenheit
-- Formula: F = C * 9/5 + 32
local function celsiusToFahrenheit(celsius)
    -- your code here
end

print("25°C in Fahrenheit:", celsiusToFahrenheit(25))

-- 6. Create a function that calculates factorial
-- factorial(5) = 5 * 4 * 3 * 2 * 1 = 120
local function factorial(n)
    -- your code here (use a loop or recursion)
end

print("Factorial of 5:", factorial(5))

-- 7. Create a function that counts vowels in a string
local function countVowels(str)
    -- your code here
    -- hint: use string.lower() and string.match()
end

print("Vowels in 'Hello World':", countVowels("Hello World"))
