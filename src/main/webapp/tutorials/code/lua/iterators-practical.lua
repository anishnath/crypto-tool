-- Practical Iterator Examples in Lua

-- CSV parser iterator
function csv_iterator(str)
    local pos = 1
    return function()
        if pos <= #str then
            local line_end = str:find("\n", pos) or #str + 1
            local line = str:sub(pos, line_end - 1)
            pos = line_end + 1
            
            local fields = {}
            for field in line:gmatch("[^,]+") do
                table.insert(fields, field)
            end
            return fields
        end
    end
end

print("=== CSV Parser ===")
local csv_data = "Alice,25,Engineer\nBob,30,Designer\nCharlie,35,Manager"
for fields in csv_iterator(csv_data) do
    print(table.concat(fields, " | "))
end

-- Word iterator
function words(str)
    local pos = 1
    return function()
        local word_start, word_end = str:find("%w+", pos)
        if word_start then
            pos = word_end + 1
            return str:sub(word_start, word_end)
        end
    end
end

print("\n=== Word iterator ===")
local text = "Hello, world! This is Lua."
for word in words(text) do
    print(word)
end

-- Batch iterator (process items in batches)
function batch_iterator(t, batch_size)
    local i = 0
    return function()
        if i < #t then
            local batch = {}
            for j = 1, batch_size do
                i = i + 1
                if t[i] then
                    table.insert(batch, t[i])
                else
                    break
                end
            end
            if #batch > 0 then
                return batch
            end
        end
    end
end

print("\n=== Batch processing (size 3) ===")
local items = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
for batch in batch_iterator(items, 3) do
    print("Batch:", table.concat(batch, ", "))
end

-- Sliding window iterator
function sliding_window(t, size)
    local i = 0
    return function()
        i = i + 1
        if i + size - 1 <= #t then
            local window = {}
            for j = i, i + size - 1 do
                table.insert(window, t[j])
            end
            return window
        end
    end
end

print("\n=== Sliding window (size 3) ===")
local sequence = {1, 2, 3, 4, 5, 6}
for window in sliding_window(sequence, 3) do
    print("Window:", table.concat(window, ", "))
end

-- Enumerate iterator (like Python's enumerate)
function enumerate(t, start)
    start = start or 1
    local i = start - 1
    return function()
        i = i + 1
        if t[i - start + 1] then
            return i, t[i - start + 1]
        end
    end
end

print("\n=== Enumerate (start at 10) ===")
local colors = {"red", "green", "blue"}
for index, color in enumerate(colors, 10) do
    print(index, color)
end
