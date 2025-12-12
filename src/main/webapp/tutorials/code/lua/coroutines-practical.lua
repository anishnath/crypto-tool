-- Coroutines Practical Examples

-- Example 1: Producer-Consumer Pattern
print("=== Producer-Consumer Pattern ===")

function producer()
    return coroutine.create(function()
        for i = 1, 5 do
            print("Producing:", i)
            coroutine.yield(i)
        end
    end)
end

function consumer(prod)
    while true do
        local status, value = coroutine.resume(prod)
        if not status or value == nil then
            break
        end
        print("Consuming:", value)
        print("Processing...")
    end
end

local prod = producer()
consumer(prod)

-- Example 2: Pipeline Processing
print("\n=== Pipeline Processing ===")

function generate_numbers(n)
    return coroutine.create(function()
        for i = 1, n do
            coroutine.yield(i)
        end
    end)
end

function filter_even(source)
    return coroutine.create(function()
        while true do
            local status, value = coroutine.resume(source)
            if not status or value == nil then
                break
            end
            if value % 2 == 0 then
                coroutine.yield(value)
            end
        end
    end)
end

function multiply_by_two(source)
    return coroutine.create(function()
        while true do
            local status, value = coroutine.resume(source)
            if not status or value == nil then
                break
            end
            coroutine.yield(value * 2)
        end
    end)
end

-- Build pipeline
local numbers = generate_numbers(10)
local evens = filter_even(numbers)
local doubled = multiply_by_two(evens)

-- Process pipeline
while true do
    local status, value = coroutine.resume(doubled)
    if not status or value == nil then
        break
    end
    print("Result:", value)
end

-- Example 3: Async Task Simulation
print("\n=== Async Task Simulation ===")

function async_task(name, duration)
    return coroutine.create(function()
        print(string.format("[%s] Starting...", name))
        for i = 1, duration do
            print(string.format("[%s] Working... %d/%d", name, i, duration))
            coroutine.yield()
        end
        print(string.format("[%s] Completed!", name))
        return name .. " result"
    end)
end

-- Run multiple tasks concurrently
local tasks = {
    async_task("Task A", 3),
    async_task("Task B", 2),
    async_task("Task C", 4)
}

local active = #tasks
while active > 0 do
    for i, task in ipairs(tasks) do
        if coroutine.status(task) ~= "dead" then
            coroutine.resume(task)
        else
            active = active - 1
            tasks[i] = nil
        end
    end
end

-- Example 4: Iterator using Coroutines
print("\n=== Coroutine Iterator ===")

function permutations(arr)
    local function permute(a, n)
        if n == 0 then
            coroutine.yield(a)
        else
            for i = 1, n do
                a[n], a[i] = a[i], a[n]
                permute(a, n - 1)
                a[n], a[i] = a[i], a[n]
            end
        end
    end
    
    return coroutine.wrap(function()
        permute(arr, #arr)
    end)
end

print("Permutations of {1, 2, 3}:")
for perm in permutations({1, 2, 3}) do
    print(table.concat(perm, ", "))
end

-- Example 5: State Machine
print("\n=== State Machine ===")

function traffic_light()
    return coroutine.create(function()
        while true do
            print("🔴 RED - Stop")
            coroutine.yield("red")
            
            print("🟢 GREEN - Go")
            coroutine.yield("green")
            
            print("🟡 YELLOW - Caution")
            coroutine.yield("yellow")
        end
    end)
end

local light = traffic_light()
for i = 1, 6 do
    local status, state = coroutine.resume(light)
    print(string.format("Cycle %d: %s\n", i, state))
end

print("=== Coroutines Practical Examples Complete ===")
