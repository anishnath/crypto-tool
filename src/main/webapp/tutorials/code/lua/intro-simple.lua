-- Welcome to Lua!
-- This is a simple example showing Lua's clean syntax

-- Variables are easy to declare
local name = "World"
local version = 5.4

-- Functions are first-class values
local function greet(person)
    return "Hello, " .. person .. "!"
end

-- Tables are Lua's main data structure
local info = {
    language = "Lua",
    year = 1993,
    creator = "Roberto Ierusalimschy"
}

-- Print some information
print(greet(name))
print("Lua version:", version)
print("Created in:", info.year)
print("By:", info.creator)
