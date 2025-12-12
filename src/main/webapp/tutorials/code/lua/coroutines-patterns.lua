-- Common Coroutine Patterns

-- 1. Iterator Pattern
print("=== Iterator Pattern ===")

local function range(from, to, step)
    step = step or 1
    return coroutine.wrap(function()
        for i = from, to, step do
            coroutine.yield(i)
        end
    end)
end

for i in range(1, 10, 2) do
    print("Odd number:", i)
end

-- 2. Producer-Consumer Pattern
print("\n=== Producer-Consumer ===")

local function producer(items)
    return coroutine.create(function()
        for i, item in ipairs(items) do
            print("Producing:", item)
            coroutine.yield(item)
        end
    end)
end

local function consumer(prod)
    while coroutine.status(prod) ~= "dead" do
        local success, item = coroutine.resume(prod)
        if success and item then
            print("Consuming:", item)
            -- Process item
        end
    end
end

local items = {"apple", "banana", "cherry"}
consumer(producer(items))

-- 3. Pipeline Pattern
print("\n=== Pipeline Pattern ===")

local function source(data)
    return coroutine.wrap(function()
        for i, v in ipairs(data) do
            coroutine.yield(v)
        end
    end)
end

local function filter(predicate, input)
    return coroutine.wrap(function()
        for value in input do
            if predicate(value) then
                coroutine.yield(value)
            end
        end
    end)
end

local function map(func, input)
    return coroutine.wrap(function()
        for value in input do
            coroutine.yield(func(value))
        end
    end)
end

local numbers = source({1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
local evens = filter(function(x) return x % 2 == 0 end, numbers)
local doubled = map(function(x) return x * 2 end, evens)

print("Pipeline results:")
for value in doubled do
    print(value)
end

-- 4. Generator Pattern
print("\n=== Generator Pattern ===")

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
print("First 10 Fibonacci numbers:")
for i = 1, 10 do
    print(i, fib())
end

-- 5. Async/Await-like Pattern
print("\n=== Async Pattern ===")

local function async(func)
    return coroutine.wrap(func)
end

local function await(promise)
    return coroutine.yield(promise)
end

local function fetchData(id)
    return async(function()
        print("Fetching data for ID:", id)
        await("simulated_delay")
        return {id = id, data = "Data for " .. id}
    end)
end

local task = fetchData(123)
local promise = task()
print("Got promise:", promise)
local result = task()
print("Got result:", result and result.data)

-- 6. State Machine Pattern
print("\n=== State Machine ===")

local function stateMachine()
    local state = "idle"
    
    return coroutine.wrap(function()
        while true do
            local event = coroutine.yield(state)
            
            if state == "idle" and event == "start" then
                state = "running"
            elseif state == "running" and event == "pause" then
                state = "paused"
            elseif state == "paused" and event == "resume" then
                state = "running"
            elseif event == "stop" then
                state = "idle"
            end
        end
    end)
end

local sm = stateMachine()
print("Initial:", sm())
print("After start:", sm("start"))
print("After pause:", sm("pause"))
print("After resume:", sm("resume"))
print("After stop:", sm("stop"))

-- 7. Lazy Sequence Pattern
print("\n=== Lazy Sequence ===")

local function take(n, iterator)
    return coroutine.wrap(function()
        local count = 0
        for value in iterator do
            if count >= n then break end
            coroutine.yield(value)
            count = count + 1
        end
    end)
end

local function infiniteSequence()
    return coroutine.wrap(function()
        local i = 1
        while true do
            coroutine.yield(i)
            i = i + 1
        end
    end)
end

print("First 5 from infinite sequence:")
for value in take(5, infiniteSequence()) do
    print(value)
end

-- 8. Cooperative Scheduler
print("\n=== Cooperative Scheduler ===")

local function scheduler()
    local tasks = {}
    
    return {
        add = function(task)
            table.insert(tasks, coroutine.create(task))
        end,
        
        run = function()
            while #tasks > 0 do
                for i = #tasks, 1, -1 do
                    local task = tasks[i]
                    if coroutine.status(task) == "dead" then
                        table.remove(tasks, i)
                    else
                        coroutine.resume(task)
                    end
                end
            end
        end
    }
end

local sched = scheduler()

sched.add(function()
    for i = 1, 3 do
        print("Task A:", i)
        coroutine.yield()
    end
end)

sched.add(function()
    for i = 1, 2 do
        print("Task B:", i)
        coroutine.yield()
    end
end)

sched.run()

-- 9. Event Loop Pattern
print("\n=== Event Loop ===")

local function eventLoop()
    local events = {}
    
    return {
        on = function(event, handler)
            events[event] = coroutine.create(handler)
        end,
        
        emit = function(event, ...)
            if events[event] then
                coroutine.resume(events[event], ...)
            end
        end
    }
end

local loop = eventLoop()

loop.on("data", function(data)
    print("Received data:", data)
end)

loop.on("error", function(err)
    print("Error occurred:", err)
end)

loop.emit("data", "Hello")
loop.emit("error", "Something went wrong")

-- 10. Backtracking Pattern
print("\n=== Backtracking ===")

local function permutations(list)
    return coroutine.wrap(function()
        local function permute(arr, n)
            if n == 0 then
                coroutine.yield(arr)
            else
                for i = 1, n do
                    arr[n], arr[i] = arr[i], arr[n]
                    permute(arr, n - 1)
                    arr[n], arr[i] = arr[i], arr[n]
                end
            end
        end
        
        local copy = {}
        for i, v in ipairs(list) do
            copy[i] = v
        end
        permute(copy, #copy)
    end)
end

print("Permutations of {1,2,3}:")
for perm in permutations({1, 2, 3}) do
    print(table.concat(perm, ", "))
end
