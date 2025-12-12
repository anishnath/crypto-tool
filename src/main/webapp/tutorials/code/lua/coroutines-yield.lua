-- Coroutine Yield and Resume

-- yield() pauses coroutine execution
-- resume() continues from where it yielded

print("=== Basic Yield and Resume ===")

local co = coroutine.create(function()
    print("Step 1")
    coroutine.yield()
    print("Step 2")
    coroutine.yield()
    print("Step 3")
end)

coroutine.resume(co)  -- Prints "Step 1"
coroutine.resume(co)  -- Prints "Step 2"
coroutine.resume(co)  -- Prints "Step 3"

-- Yielding values
print("\n=== Yielding Values ===")

local co2 = coroutine.create(function()
    coroutine.yield("first")
    coroutine.yield("second")
    coroutine.yield("third")
    return "done"
end)

print(coroutine.resume(co2))  -- true, "first"
print(coroutine.resume(co2))  -- true, "second"
print(coroutine.resume(co2))  -- true, "third"
print(coroutine.resume(co2))  -- true, "done"

-- Receiving values after yield
print("\n=== Receiving Values ===")

local co3 = coroutine.create(function(initial)
    print("Initial value:", initial)
    local x = coroutine.yield("waiting")
    print("Received:", x)
    local y = coroutine.yield("waiting again")
    print("Received:", y)
    return "finished"
end)

print(coroutine.resume(co3, "start"))  -- true, "waiting"
print(coroutine.resume(co3, 100))      -- true, "waiting again"
print(coroutine.resume(co3, 200))      -- true, "finished"

-- Counter with coroutine
print("\n=== Counter Coroutine ===")

local function createCounter(start, max)
    return coroutine.create(function()
        for i = start, max do
            coroutine.yield(i)
        end
    end)
end

local counter = createCounter(1, 5)
while coroutine.status(counter) ~= "dead" do
    local success, value = coroutine.resume(counter)
    if success and value then
        print("Count:", value)
    end
end

-- Generator pattern
print("\n=== Generator Pattern ===")

local function generator(func)
    return coroutine.wrap(func)
end

local numbers = generator(function()
    for i = 1, 5 do
        coroutine.yield(i * 2)
    end
end)

for value in numbers do
    print("Generated:", value)
end

-- Stateful iteration
print("\n=== Stateful Iteration ===")

local function statefulIterator()
    local state = {count = 0, sum = 0}
    
    return coroutine.wrap(function()
        while true do
            local value = coroutine.yield(state)
            if not value then break end
            state.count = state.count + 1
            state.sum = state.sum + value
        end
    end)
end

local iter = statefulIterator()
iter()  -- Initialize
print("State after 10:", iter(10))
print("State after 20:", iter(20))
print("State after 30:", iter(30))

-- Pipeline pattern
print("\n=== Pipeline Pattern ===")

local function filter(predicate, source)
    return coroutine.wrap(function()
        for value in source do
            if predicate(value) then
                coroutine.yield(value)
            end
        end
    end)
end

local function map(func, source)
    return coroutine.wrap(function()
        for value in source do
            coroutine.yield(func(value))
        end
    end)
end

local function range(n)
    return coroutine.wrap(function()
        for i = 1, n do
            coroutine.yield(i)
        end
    end)
end

-- Create pipeline
local numbers = range(10)
local evens = filter(function(x) return x % 2 == 0 end, numbers)
local doubled = map(function(x) return x * 2 end, evens)

print("Pipeline results:")
for value in doubled do
    print(value)
end

-- Cooperative multitasking
print("\n=== Cooperative Multitasking ===")

local function task(name, steps)
    return coroutine.create(function()
        for i = 1, steps do
            print(name .. " - step " .. i)
            coroutine.yield()
        end
        print(name .. " - done")
    end)
end

local tasks = {
    task("Task A", 3),
    task("Task B", 2),
    task("Task C", 4)
}

-- Run all tasks cooperatively
local allDone = false
while not allDone do
    allDone = true
    for i, t in ipairs(tasks) do
        if coroutine.status(t) ~= "dead" then
            coroutine.resume(t)
            allDone = false
        end
    end
end

-- Data stream processing
print("\n=== Data Stream ===")

local function dataStream()
    return coroutine.wrap(function()
        local data = {10, 20, 30, 40, 50}
        for i, value in ipairs(data) do
            coroutine.yield(value)
        end
    end)
end

local function processStream(stream)
    local sum = 0
    for value in stream do
        sum = sum + value
        print("Processing:", value, "Sum so far:", sum)
    end
    return sum
end

local total = processStream(dataStream())
print("Total:", total)

-- Lazy evaluation
print("\n=== Lazy Evaluation ===")

local function lazyMap(func, list)
    return coroutine.wrap(function()
        for i, v in ipairs(list) do
            print("Computing:", v)
            coroutine.yield(func(v))
        end
    end)
end

local data = {1, 2, 3, 4, 5}
local squared = lazyMap(function(x) return x * x end, data)

print("Taking first 3:")
for i = 1, 3 do
    print("Result:", squared())
end
