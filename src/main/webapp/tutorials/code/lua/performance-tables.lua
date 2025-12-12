-- Table Performance Optimization in Lua

-- Tables are Lua's primary data structure
-- Optimizing table usage is crucial for performance

print("=== Pre-sizing Tables ===")

-- Slow: Growing table dynamically
local function slowTableGrowth()
    local t = {}
    for i = 1, 100000 do
        t[i] = i
    end
    return t
end

-- Faster: Direct assignment (Lua handles this well)
local function fastTableGrowth()
    local t = {}
    for i = 1, 100000 do
        t[i] = i
    end
    return t
end

-- Note: Lua 5.1+ handles table growth efficiently
-- Pre-allocation isn't as critical as in other languages

print("=== Array vs table.insert ===")

-- Slower: Using table.insert
local function withInsert()
    local t = {}
    for i = 1, 10000 do
        table.insert(t, i)
    end
    return t
end

-- Faster: Direct assignment
local function withAssignment()
    local t = {}
    for i = 1, 10000 do
        t[i] = i
    end
    return t
end

-- Benchmark
local start = os.clock()
withInsert()
print("table.insert:", os.clock() - start)

start = os.clock()
withAssignment()
print("Direct assignment:", os.clock() - start)

print("\n=== Table Reuse ===")

-- Slow: Creating new tables
local function manyTables()
    for i = 1, 10000 do
        local temp = {x = i, y = i * 2}
        -- use temp
    end
end

-- Faster: Reusing table
local function reuseTable()
    local temp = {}
    for i = 1, 10000 do
        temp.x = i
        temp.y = i * 2
        -- use temp
    end
end

start = os.clock()
manyTables()
print("Many tables:", os.clock() - start)

start = os.clock()
reuseTable()
print("Reuse table:", os.clock() - start)

print("\n=== Table Iteration ===")

local data = {}
for i = 1, 10000 do
    data[i] = i
end

-- Slower: pairs (checks all keys)
local function withPairs()
    local sum = 0
    for k, v in pairs(data) do
        sum = sum + v
    end
    return sum
end

-- Faster: ipairs (optimized for arrays)
local function withIpairs()
    local sum = 0
    for i, v in ipairs(data) do
        sum = sum + v
    end
    return sum
end

-- Fastest: numeric for
local function withNumericFor()
    local sum = 0
    for i = 1, #data do
        sum = sum + data[i]
    end
    return sum
end

start = os.clock()
withPairs()
print("pairs:", os.clock() - start)

start = os.clock()
withIpairs()
print("ipairs:", os.clock() - start)

start = os.clock()
withNumericFor()
print("numeric for:", os.clock() - start)

print("\n=== Table Copying ===")

-- Shallow copy
local function shallowCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end

-- Deep copy (recursive)
local function deepCopy(t)
    if type(t) ~= "table" then
        return t
    end
    
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = deepCopy(v)
    end
    return copy
end

print("\n=== Table Concatenation ===")

-- Slow: String concatenation
local function slowConcat()
    local result = ""
    for i = 1, 1000 do
        result = result .. tostring(i)
    end
    return result
end

-- Fast: table.concat
local function fastConcat()
    local t = {}
    for i = 1, 1000 do
        t[i] = tostring(i)
    end
    return table.concat(t)
end

start = os.clock()
slowConcat()
print("String concat:", os.clock() - start)

start = os.clock()
fastConcat()
print("table.concat:", os.clock() - start)

print("\n=== Avoid Table Lookups in Loops ===")

local config = {
    settings = {
        timeout = 30
    }
}

-- Slow: Repeated lookups
local function slowLookup()
    for i = 1, 10000 do
        local timeout = config.settings.timeout
        -- use timeout
    end
end

-- Fast: Cache lookup
local function fastLookup()
    local timeout = config.settings.timeout
    for i = 1, 10000 do
        -- use timeout
    end
end

start = os.clock()
slowLookup()
print("Repeated lookups:", os.clock() - start)

start = os.clock()
fastLookup()
print("Cached lookup:", os.clock() - start)

print("\n=== Table.remove Performance ===")

-- Slow: Removing from beginning
local function removeFromStart()
    local t = {}
    for i = 1, 1000 do
        t[i] = i
    end
    
    for i = 1, 500 do
        table.remove(t, 1)  -- Shifts all elements
    end
end

-- Faster: Removing from end
local function removeFromEnd()
    local t = {}
    for i = 1, 1000 do
        t[i] = i
    end
    
    for i = 1, 500 do
        table.remove(t)  -- No shifting needed
    end
end

start = os.clock()
removeFromStart()
print("Remove from start:", os.clock() - start)

start = os.clock()
removeFromEnd()
print("Remove from end:", os.clock() - start)

print("\n=== Weak Tables for Caching ===")

-- Use weak tables for caches to allow garbage collection
local cache = {}
setmetatable(cache, {__mode = "v"})  -- Weak values

local function getCached(key)
    if not cache[key] then
        cache[key] = expensiveComputation(key)
    end
    return cache[key]
end

function expensiveComputation(x)
    return x * x
end

print("Cached value:", getCached(10))
print("Cached value:", getCached(10))  -- Uses cache
