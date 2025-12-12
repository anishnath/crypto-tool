-- Reading Files in Lua

-- Lua provides io library for file operations

print("=== Reading Entire File ===")

-- Read entire file
local function readEntireFile(filename)
    local file = io.open(filename, "r")
    if not file then
        return nil, "Could not open file"
    end
    
    local content = file:read("*all")
    file:close()
    return content
end

-- Example (file may not exist)
-- local content, err = readEntireFile("test.txt")
-- if content then
--     print(content)
-- else
--     print("Error:", err)
-- end

-- Read line by line
print("\n=== Reading Line by Line ===")

local function readLines(filename)
    local file = io.open(filename, "r")
    if not file then
        return nil, "Could not open file"
    end
    
    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()
    return lines
end

-- Read with pattern
print("\n=== Reading with Patterns ===")

local function readNumbers(filename)
    local file = io.open(filename, "r")
    if not file then
        return nil, "Could not open file"
    end
    
    local numbers = {}
    for line in file:lines() do
        for num in line:gmatch("%d+") do
            table.insert(numbers, tonumber(num))
        end
    end
    file:close()
    return numbers
end

-- Read specific number of bytes
print("\n=== Reading Bytes ===")

local function readBytes(filename, n)
    local file = io.open(filename, "rb")  -- Binary mode
    if not file then
        return nil, "Could not open file"
    end
    
    local data = file:read(n)
    file:close()
    return data
end

-- Safe file reading with pcall
print("\n=== Safe File Reading ===")

local function safeReadFile(filename)
    local ok, result = pcall(function()
        local file = assert(io.open(filename, "r"))
        local content = file:read("*all")
        file:close()
        return content
    end)
    
    if ok then
        return result
    else
        return nil, result
    end
end

-- Read with automatic cleanup
print("\n=== Automatic Cleanup ===")

local function withFile(filename, mode, func)
    local file = io.open(filename, mode)
    if not file then
        return nil, "Could not open file"
    end
    
    local ok, result = pcall(func, file)
    file:close()
    
    if ok then
        return result
    else
        return nil, result
    end
end

-- Usage:
-- local content = withFile("test.txt", "r", function(file)
--     return file:read("*all")
-- end)

-- Read CSV file
print("\n=== Reading CSV ===")

local function readCSV(filename)
    local file = io.open(filename, "r")
    if not file then
        return nil, "Could not open file"
    end
    
    local rows = {}
    for line in file:lines() do
        local row = {}
        for value in line:gmatch("[^,]+") do
            table.insert(row, value)
        end
        table.insert(rows, row)
    end
    file:close()
    return rows
end

-- Read JSON-like file (simplified)
print("\n=== Reading Structured Data ===")

local function readKeyValue(filename)
    local file = io.open(filename, "r")
    if not file then
        return nil, "Could not open file"
    end
    
    local data = {}
    for line in file:lines() do
        local key, value = line:match("(%w+)%s*=%s*(.+)")
        if key and value then
            data[key] = value
        end
    end
    file:close()
    return data
end

-- Read file in chunks
print("\n=== Reading in Chunks ===")

local function readInChunks(filename, chunkSize)
    local file = io.open(filename, "r")
    if not file then
        return nil, "Could not open file"
    end
    
    local chunks = {}
    while true do
        local chunk = file:read(chunkSize)
        if not chunk then break end
        table.insert(chunks, chunk)
    end
    file:close()
    return chunks
end

-- Check if file exists
print("\n=== File Existence Check ===")

local function fileExists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

print("File exists:", fileExists("test.txt"))

-- Read file with error handling
print("\n=== Robust File Reading ===")

local function robustRead(filename)
    local file, err = io.open(filename, "r")
    if not file then
        return nil, "Failed to open: " .. err
    end
    
    local content, readErr = file:read("*all")
    file:close()
    
    if not content then
        return nil, "Failed to read: " .. readErr
    end
    
    return content
end

-- Read file iterator
print("\n=== File Iterator ===")

local function fileLines(filename)
    local file = io.open(filename, "r")
    if not file then
        return function() return nil end
    end
    
    return function()
        local line = file:read("*line")
        if not line then
            file:close()
        end
        return line
    end
end

-- Usage:
-- for line in fileLines("test.txt") do
--     print(line)
-- end

-- Read with default value
print("\n=== Read with Default ===")

local function readOrDefault(filename, default)
    local content, err = safeReadFile(filename)
    return content or default
end

local config = readOrDefault("config.txt", "default config")
print("Config:", config)
