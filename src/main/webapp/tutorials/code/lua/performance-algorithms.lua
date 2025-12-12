-- Performance: Algorithm Optimization

-- Example 1: Efficient Table Insertion
print("=== Table Insertion Performance ===")

-- Inefficient: Using table.insert in loop
local function slow_build_table(n)
    local t = {}
    for i = 1, n do
        table.insert(t, i)  -- Slower
    end
    return t
end

-- Efficient: Direct index assignment
local function fast_build_table(n)
    local t = {}
    for i = 1, n do
        t[i] = i  -- Faster
    end
    return t
end

local n = 10
print("Building table with", n, "elements")
print("Slow method:", #slow_build_table(n), "elements")
print("Fast method:", #fast_build_table(n), "elements")

-- Example 2: String Concatenation
print("\n=== String Concatenation ===")

-- Inefficient: Using .. in loop
local function slow_concat(n)
    local s = ""
    for i = 1, n do
        s = s .. i .. ","  -- Creates new string each time
    end
    return s
end

-- Efficient: Using table.concat
local function fast_concat(n)
    local t = {}
    for i = 1, n do
        t[i] = i
    end
    return table.concat(t, ",")
end

local count = 10
print("Slow concat:", slow_concat(count))
print("Fast concat:", fast_concat(count))

-- Example 3: Memoization for Fibonacci
print("\n=== Memoization ===")

-- Without memoization (slow for large n)
local function fib_slow(n)
    if n <= 1 then
        return n
    end
    return fib_slow(n - 1) + fib_slow(n - 2)
end

-- With memoization (fast)
local fib_cache = {}
local function fib_fast(n)
    if n <= 1 then
        return n
    end
    if not fib_cache[n] then
        fib_cache[n] = fib_fast(n - 1) + fib_fast(n - 2)
    end
    return fib_cache[n]
end

print("Fibonacci(10) slow:", fib_slow(10))
print("Fibonacci(10) fast:", fib_fast(10))
print("Fibonacci(20) fast:", fib_fast(20))

-- Example 4: Efficient Searching
print("\n=== Binary Search vs Linear Search ===")

-- Linear search (O(n))
local function linear_search(arr, target)
    for i, v in ipairs(arr) do
        if v == target then
            return i
        end
    end
    return nil
end

-- Binary search (O(log n)) - requires sorted array
local function binary_search(arr, target)
    local low, high = 1, #arr
    while low <= high do
        local mid = math.floor((low + high) / 2)
        if arr[mid] == target then
            return mid
        elseif arr[mid] < target then
            low = mid + 1
        else
            high = mid - 1
        end
    end
    return nil
end

local sorted_array = {2, 5, 8, 12, 16, 23, 38, 45, 56, 67, 78}
local target = 23

print("Linear search for", target, "found at:", linear_search(sorted_array, target))
print("Binary search for", target, "found at:", binary_search(sorted_array, target))

-- Example 5: Efficient Sorting
print("\n=== Sorting Algorithms ===")

-- Bubble sort (O(n²)) - slow
local function bubble_sort(arr)
    local n = #arr
    for i = 1, n do
        for j = 1, n - i do
            if arr[j] > arr[j + 1] then
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
            end
        end
    end
    return arr
end

-- Quick sort (O(n log n)) - fast
local function quick_sort(arr, low, high)
    low = low or 1
    high = high or #arr
    
    if low < high then
        local function partition(arr, low, high)
            local pivot = arr[high]
            local i = low - 1
            for j = low, high - 1 do
                if arr[j] <= pivot then
                    i = i + 1
                    arr[i], arr[j] = arr[j], arr[i]
                end
            end
            arr[i + 1], arr[high] = arr[high], arr[i + 1]
            return i + 1
        end
        
        local pi = partition(arr, low, high)
        quick_sort(arr, low, pi - 1)
        quick_sort(arr, pi + 1, high)
    end
    return arr
end

local unsorted = {64, 34, 25, 12, 22, 11, 90}
local arr1 = {64, 34, 25, 12, 22, 11, 90}
local arr2 = {64, 34, 25, 12, 22, 11, 90}

print("Original:", table.concat(unsorted, ", "))
print("Bubble sort:", table.concat(bubble_sort(arr1), ", "))
print("Quick sort:", table.concat(quick_sort(arr2), ", "))

-- Example 6: Loop Optimization
print("\n=== Loop Optimization ===")

-- Inefficient: Recalculating length
local function slow_loop(arr)
    local sum = 0
    for i = 1, #arr do  -- #arr calculated each iteration
        sum = sum + arr[i]
    end
    return sum
end

-- Efficient: Cache length
local function fast_loop(arr)
    local sum = 0
    local n = #arr  -- Calculate once
    for i = 1, n do
        sum = sum + arr[i]
    end
    return sum
end

local numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
print("Sum (slow):", slow_loop(numbers))
print("Sum (fast):", fast_loop(numbers))

-- Example 7: Avoiding Global Variables
print("\n=== Local vs Global Variables ===")

-- Slower: Using global
global_sum = 0
local function use_global(arr)
    for i = 1, #arr do
        global_sum = global_sum + arr[i]
    end
    return global_sum
end

-- Faster: Using local
local function use_local(arr)
    local sum = 0
    for i = 1, #arr do
        sum = sum + arr[i]
    end
    return sum
end

print("Using global:", use_global(numbers))
print("Using local:", use_local(numbers))

print("\n=== Algorithm Optimization Complete ===")
