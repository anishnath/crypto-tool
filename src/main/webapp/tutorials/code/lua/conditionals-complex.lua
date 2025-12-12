-- Complex and Nested Conditionals

-- Nested if statements
local age = 25
local hasLicense = true

if age >= 18 then
    if hasLicense then
        print("You can drive")
    else
        print("You need a license")
    end
else
    print("You're too young to drive")
end

-- Complex logical conditions
local username = "admin"
local password = "secret123"
local isActive = true

if (username == "admin" or username == "root") and 
   password == "secret123" and 
   isActive then
    print("Access granted")
else
    print("Access denied")
end

-- Range checking
local score = 75

if score >= 0 and score <= 100 then
    if score >= 90 then
        print("Excellent!")
    elseif score >= 70 then
        print("Good job!")
    elseif score >= 50 then
        print("You passed")
    else
        print("Need improvement")
    end
else
    print("Invalid score")
end

-- Multiple variable checks
local x, y = 10, 20

if x > 0 and y > 0 then
    print("Both positive")
elseif x < 0 and y < 0 then
    print("Both negative")
else
    print("Mixed signs")
end

-- Type checking
local value = "Hello"

if type(value) == "string" then
    print("It's a string:", value)
elseif type(value) == "number" then
    print("It's a number:", value)
elseif type(value) == "boolean" then
    print("It's a boolean:", value)
else
    print("Unknown type:", type(value))
end

-- Guard clauses (early return pattern)
local function checkAge(age)
    if age == nil then
        print("Age is required")
        return
    end
    
    if age < 0 then
        print("Invalid age")
        return
    end
    
    if age < 18 then
        print("Minor")
    else
        print("Adult")
    end
end

checkAge(25)
checkAge(nil)
checkAge(-5)
