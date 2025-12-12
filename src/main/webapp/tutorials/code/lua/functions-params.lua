-- Function Parameters and Arguments

-- Default parameter values (using 'or')
local function greet(name)
    name = name or "Guest"  -- Default to "Guest" if nil
    print("Hello, " .. name)
end

greet("Alice")
greet()  -- Uses default

-- Multiple parameters
local function calculateArea(length, width)
    return length * width
end

print("Area:", calculateArea(5, 3))

-- Optional parameters
local function createUser(name, age, city)
    age = age or 18
    city = city or "Unknown"
    
    print("Name:", name)
    print("Age:", age)
    print("City:", city)
end

createUser("Alice", 25, "NYC")
createUser("Bob", 30)
createUser("Charlie")

-- Passing tables as parameters
local function printPerson(person)
    print("Name:", person.name)
    print("Age:", person.age)
end

local user = {name = "Alice", age = 25}
printPerson(user)

-- Modifying parameters (pass by value for primitives)
local function tryToModify(x)
    x = x + 10
    print("Inside function:", x)
end

local num = 5
tryToModify(num)
print("Outside function:", num)  -- Still 5!

-- Modifying tables (pass by reference)
local function modifyTable(t)
    t.value = 100
end

local myTable = {value = 10}
print("Before:", myTable.value)
modifyTable(myTable)
print("After:", myTable.value)  -- Changed!

-- Named arguments pattern (using tables)
local function createProfile(options)
    local name = options.name or "Unknown"
    local age = options.age or 0
    local email = options.email or "none"
    
    print(string.format("Profile: %s, %d, %s", name, age, email))
end

createProfile({name = "Alice", age = 25, email = "alice@example.com"})
createProfile({name = "Bob", age = 30})
