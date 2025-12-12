-- Variadic Functions in Lua (using ...)

-- Basic variadic function
local function printAll(...)
    local args = {...}  -- Pack into table
    for i, v in ipairs(args) do
        print(i, v)
    end
end

print("=== Print All ===")
printAll("Hello", "World", 42, true)

-- Getting number of arguments
local function countArgs(...)
    return select("#", ...)
end

print("\n=== Count Args ===")
print("Number of args:", countArgs(1, 2, 3, 4, 5))
print("Number of args:", countArgs("a", "b"))

-- Sum all numbers
local function sum(...)
    local total = 0
    for i, v in ipairs({...}) do
        total = total + v
    end
    return total
end

print("\n=== Sum ===")
print("Sum:", sum(1, 2, 3, 4, 5))
print("Sum:", sum(10, 20, 30))

-- Mixed parameters and varargs
local function greetAll(greeting, ...)
    local names = {...}
    for i, name in ipairs(names) do
        print(greeting .. ", " .. name .. "!")
    end
end

print("\n=== Greet All ===")
greetAll("Hello", "Alice", "Bob", "Charlie")

-- Using select() to access specific arguments
local function getSecondArg(...)
    return select(2, ...)
end

print("\n=== Select ===")
print("Second arg:", getSecondArg("first", "second", "third"))

-- select() to get remaining arguments
local function skipFirst(...)
    return select(2, ...)
end

local a, b, c = skipFirst(1, 2, 3, 4)
print("After skipping first:", a, b, c)

-- Forwarding arguments
local function wrapper(...)
    print("Before call")
    local results = {sum(...)}
    print("After call")
    return table.unpack(results)
end

print("\n=== Wrapper ===")
print("Result:", wrapper(5, 10, 15))

-- Finding maximum
local function max(...)
    local args = {...}
    if #args == 0 then return nil end
    
    local maximum = args[1]
    for i = 2, #args do
        if args[i] > maximum then
            maximum = args[i]
        end
    end
    return maximum
end

print("\n=== Max ===")
print("Max:", max(10, 25, 5, 30, 15))

-- String concatenation
local function concat(separator, ...)
    local args = {...}
    return table.concat(args, separator)
end

print("\n=== Concat ===")
print(concat(", ", "apple", "banana", "cherry"))
print(concat(" - ", "one", "two", "three"))

-- Variadic with default values
local function createList(...)
    local list = {...}
    if #list == 0 then
        return {"default"}
    end
    return list
end

print("\n=== Create List ===")
local list1 = createList("a", "b", "c")
print("List 1:", table.concat(list1, ", "))

local list2 = createList()
print("List 2:", table.concat(list2, ", "))
