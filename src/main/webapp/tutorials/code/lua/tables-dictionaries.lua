-- Dictionaries in Lua (Associative Arrays)

-- Creating a dictionary
local person = {
    name = "Alice",
    age = 25,
    city = "New York",
    email = "alice@example.com"
}

print("=== Basic Dictionary ===")
print("Name:", person.name)
print("Age:", person.age)
print("City:", person.city)

-- Two ways to access values
print("\n=== Access Methods ===")
print("Dot notation:", person.name)
print("Bracket notation:", person["name"])

-- Bracket notation allows dynamic keys
local key = "age"
print("Dynamic key:", person[key])

-- Adding new keys
person.phone = "555-1234"
person["country"] = "USA"

print("\n=== After Adding ===")
print("Phone:", person.phone)
print("Country:", person.country)

-- Modifying values
person.age = 26
print("\nNew age:", person.age)

-- Removing keys (set to nil)
person.email = nil
print("Email after removal:", person.email)  -- nil

-- Iterating with pairs
print("\n=== Iteration ===")
for key, value in pairs(person) do
    print(key, "=", value)
end

-- Nested dictionaries
local company = {
    name = "TechCorp",
    address = {
        street = "123 Main St",
        city = "San Francisco",
        zip = "94102"
    },
    employees = 50
}

print("\n=== Nested Dictionary ===")
print("Company:", company.name)
print("Street:", company.address.street)
print("City:", company.address.city)

-- Dictionary of dictionaries
local users = {
    user1 = {name = "Alice", role = "admin"},
    user2 = {name = "Bob", role = "user"},
    user3 = {name = "Charlie", role = "moderator"}
}

print("\n=== Dictionary of Dictionaries ===")
for userId, userData in pairs(users) do
    print(userId .. ":", userData.name, "-", userData.role)
end

-- Checking if key exists
if person.name then
    print("\nName exists:", person.name)
end

if person.email == nil then
    print("Email does not exist")
end

-- Counting keys
local function countKeys(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

print("\nNumber of keys in person:", countKeys(person))

-- Merging dictionaries
local defaults = {theme = "dark", lang = "en"}
local settings = {theme = "light"}

local function merge(t1, t2)
    local result = {}
    for k, v in pairs(t1) do
        result[k] = v
    end
    for k, v in pairs(t2) do
        result[k] = v  -- Overwrites if exists
    end
    return result
end

local config = merge(defaults, settings)
print("\n=== Merged Config ===")
for k, v in pairs(config) do
    print(k, "=", v)
end

-- Keys can be any type (except nil)
local weird = {
    [1] = "number key",
    ["string"] = "string key",
    [true] = "boolean key",
    [{}] = "table key"
}

print("\n=== Various Key Types ===")
print("Number key:", weird[1])
print("String key:", weird["string"])
print("Boolean key:", weird[true])
