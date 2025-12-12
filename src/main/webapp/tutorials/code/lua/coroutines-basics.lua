-- Coroutines Basics in Lua

-- Coroutines allow cooperative multitasking
-- They can pause and resume execution

print("=== Creating Coroutines ===")

-- Create a coroutine
local co = coroutine.create(function()
    print("Hello from coroutine!")
end)

-- Check status
print("Status:", coroutine.status(co))  -- suspended

-- Resume the coroutine
coroutine.resume(co)
print("Status after resume:", coroutine.status(co))  -- dead

-- Coroutine with yield
print("\n=== Coroutine with Yield ===")

local co2 = coroutine.create(function()
    print("Coroutine started")
    coroutine.yield()
    print("Coroutine resumed")
    coroutine.yield()
    print("Coroutine finished")
end)

coroutine.resume(co2)  -- Prints "Coroutine started"
coroutine.resume(co2)  -- Prints "Coroutine resumed"
coroutine.resume(co2)  -- Prints "Coroutine finished"

-- Passing values
print("\n=== Passing Values ===")

local co3 = coroutine.create(function(a, b)
    print("Received:", a, b)
    local x, y = coroutine.yield(a + b)
    print("Received after yield:", x, y)
    return x * y
end)

local success, result = coroutine.resume(co3, 10, 20)
print("First resume result:", result)  -- 30

local success2, result2 = coroutine.resume(co3, 5, 6)
print("Second resume result:", result2)  -- 30

-- Coroutine status
print("\n=== Coroutine Status ===")

local co4 = coroutine.create(function()
    coroutine.yield()
end)

print("Initial:", coroutine.status(co4))     -- suspended
coroutine.resume(co4)
print("After first resume:", coroutine.status(co4))  -- suspended
coroutine.resume(co4)
print("After second resume:", coroutine.status(co4))  -- dead

-- Producer-Consumer pattern
print("\n=== Producer-Consumer ===")

local function producer()
    return coroutine.create(function()
        for i = 1, 5 do
            print("Producing:", i)
            coroutine.yield(i)
        end
    end)
end

local function consumer(prod)
    while true do
        local status, value = coroutine.resume(prod)
        if not status or coroutine.status(prod) == "dead" then
            break
        end
        print("Consuming:", value)
    end
end

local prod = producer()
consumer(prod)

-- Coroutine wrap
print("\n=== coroutine.wrap ===")

local co5 = coroutine.wrap(function()
    for i = 1, 3 do
        print("Iteration:", i)
        coroutine.yield()
    end
end)

co5()  -- First iteration
co5()  -- Second iteration
co5()  -- Third iteration

-- Iterator using coroutine
print("\n=== Coroutine Iterator ===")

local function range(n)
    return coroutine.wrap(function()
        for i = 1, n do
            coroutine.yield(i)
        end
    end)
end

for i in range(5) do
    print("Value:", i)
end

-- Fibonacci with coroutine
print("\n=== Fibonacci Generator ===")

local function fibonacci()
    return coroutine.wrap(function()
        local a, b = 0, 1
        while true do
            coroutine.yield(a)
            a, b = b, a + b
        end
    end)
end

local fib = fibonacci()
for i = 1, 10 do
    print("Fib", i .. ":", fib())
end

-- Coroutine for async-like operations
print("\n=== Async-like Pattern ===")

local function asyncTask(name, duration)
    return coroutine.create(function()
        print(name .. " started")
        for i = 1, duration do
            print(name .. " working... " .. i .. "/" .. duration)
            coroutine.yield()
        end
        print(name .. " completed")
        return name .. " result"
    end)
end

local task1 = asyncTask("Task1", 3)
local task2 = asyncTask("Task2", 2)

-- Run tasks concurrently
while coroutine.status(task1) ~= "dead" or coroutine.status(task2) ~= "dead" do
    if coroutine.status(task1) ~= "dead" then
        coroutine.resume(task1)
    end
    if coroutine.status(task2) ~= "dead" then
        coroutine.resume(task2)
    end
end

-- Error handling in coroutines
print("\n=== Error Handling ===")

local co6 = coroutine.create(function()
    print("Before error")
    error("Coroutine error!")
    print("After error")  -- Won't execute
end)

local success, err = coroutine.resume(co6)
if not success then
    print("Error caught:", err)
end

-- Coroutine running check
print("\n=== Running Coroutine ===")

local co7 = coroutine.create(function()
    print("Running coroutine:", coroutine.running())
end)

print("Main thread:", coroutine.running())
coroutine.resume(co7)
