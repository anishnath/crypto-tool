-- Stateful Iterator Examples in Lua

-- Stateful iterator using closure
function file_lines(filename)
    local file = io.open(filename)
    return function()
        if file then
            local line = file:read()
            if line then
                return line
            else
                file:close()
                file = nil
            end
        end
    end
end

-- Stateful iterator for Fibonacci sequence
function fibonacci()
    local a, b = 0, 1
    return function()
        a, b = b, a + b
        return a
    end
end

print("=== Fibonacci sequence (first 10) ===")
local fib = fibonacci()
for i = 1, 10 do
    print(fib())
end

-- Stateful iterator with state object
function counter(start, step)
    local state = {
        current = start,
        step = step or 1
    }
    
    return function()
        local value = state.current
        state.current = state.current + state.step
        return value
    end
end

print("\n=== Counter from 10, step 3 ===")
local count = counter(10, 3)
for i = 1, 5 do
    print(count())
end

-- Stateful iterator for unique values
function unique_iterator(t)
    local seen = {}
    local i = 0
    
    return function()
        i = i + 1
        while t[i] do
            if not seen[t[i]] then
                seen[t[i]] = true
                return t[i]
            end
            i = i + 1
        end
    end
end

print("\n=== Unique values ===")
local items = {1, 2, 2, 3, 1, 4, 3, 5}
for value in unique_iterator(items) do
    print(value)
end
