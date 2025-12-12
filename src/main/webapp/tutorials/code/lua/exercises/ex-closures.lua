-- Exercise: Closures
-- TODO: Complete the following exercises

-- 1. Create a counter that can increment, decrement, and reset
local function createCounter()
    -- your code here
    -- return table with increment, decrement, reset, getValue methods
end

local counter = createCounter()
-- counter.increment()
-- counter.increment()
-- print("Value:", counter.getValue())

-- 2. Create a function that generates unique IDs
local function createIDGenerator()
    -- your code here
    -- return a function that returns incrementing IDs
end

local getID = createIDGenerator()
-- print("ID 1:", getID())
-- print("ID 2:", getID())
-- print("ID 3:", getID())

-- 3. Create a temperature converter factory
local function createConverter(fromUnit, toUnit)
    -- your code here
    -- return a function that converts temperatures
    -- C to F: F = C * 9/5 + 32
    -- F to C: C = (F - 32) * 5/9
end

local celsiusToFahrenheit = createConverter("C", "F")
local fahrenheitToCelsius = createConverter("F", "C")
-- print("25°C =", celsiusToFahrenheit(25), "°F")
-- print("77°F =", fahrenheitToCelsius(77), "°C")

-- 4. Create a simple shopping cart
local function createShoppingCart()
    -- your code here
    -- return table with addItem, removeItem, getTotal, getItems methods
    -- items should have name and price
end

local cart = createShoppingCart()
-- cart.addItem("Apple", 1.50)
-- cart.addItem("Banana", 0.75)
-- print("Total:", cart.getTotal())

-- 5. Create a function that remembers the last N calls
local function createHistory(maxSize)
    -- your code here
    -- return a function that stores its arguments in history
    -- and a getHistory function
end

local func, getHistory = createHistory(3)
-- func("first")
-- func("second")
-- func("third")
-- func("fourth")  -- Should remove "first"
-- print(getHistory())  -- Should show last 3
