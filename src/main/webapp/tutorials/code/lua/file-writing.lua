-- Writing Files in Lua

-- Lua provides io library for file writing

print("=== Writing to File ===")

-- Write string to file
local function writeFile(filename, content)
    local file = io.open(filename, "w")
    if not file then
        return false, "Could not open file for writing"
    end
    
    file:write(content)
    file:close()
    return true
end

-- Example
writeFile("output.txt", "Hello, World!\n")
print("File written")

-- Append to file
print("\n=== Appending to File ===")

local function appendFile(filename, content)
    local file = io.open(filename, "a")
    if not file then
        return false, "Could not open file for appending"
    end
    
    file:write(content)
    file:close()
    return true
end

appendFile("output.txt", "Appended line\n")

-- Write multiple lines
print("\n=== Writing Multiple Lines ===")

local function writeLines(filename, lines)
    local file = io.open(filename, "w")
    if not file then
        return false, "Could not open file"
    end
    
    for i, line in ipairs(lines) do
        file:write(line, "\n")
    end
    file:close()
    return true
end

local lines = {"Line 1", "Line 2", "Line 3"}
writeLines("lines.txt", lines)

-- Write formatted data
print("\n=== Writing Formatted Data ===")

local function writeFormatted(filename, data)
    local file = io.open(filename, "w")
    if not file then
        return false, "Could not open file"
    end
    
    for key, value in pairs(data) do
        file:write(string.format("%s = %s\n", key, tostring(value)))
    end
    file:close()
    return true
end

local config = {
    debug = true,
    timeout = 30,
    maxRetries = 3
}
writeFormatted("config.txt", config)

-- Write CSV
print("\n=== Writing CSV ===")

local function writeCSV(filename, rows)
    local file = io.open(filename, "w")
    if not file then
        return false, "Could not open file"
    end
    
    for i, row in ipairs(rows) do
        file:write(table.concat(row, ","), "\n")
    end
    file:close()
    return true
end

local csvData = {
    {"Name", "Age", "City"},
    {"Alice", "25", "New York"},
    {"Bob", "30", "London"}
}
writeCSV("data.csv", csvData)

-- Safe file writing
print("\n=== Safe File Writing ===")

local function safeWriteFile(filename, content)
    local ok, err = pcall(function()
        local file = assert(io.open(filename, "w"))
        file:write(content)
        file:close()
    end)
    
    if ok then
        return true
    else
        return false, err
    end
end

-- Write with automatic cleanup
print("\n=== Automatic Cleanup ===")

local function withFileWrite(filename, mode, func)
    local file = io.open(filename, mode)
    if not file then
        return false, "Could not open file"
    end
    
    local ok, err = pcall(func, file)
    file:close()
    
    return ok, err
end

-- Usage:
withFileWrite("test.txt", "w", function(file)
    file:write("Hello from closure\n")
end)

-- Write binary data
print("\n=== Writing Binary Data ===")

local function writeBinary(filename, data)
    local file = io.open(filename, "wb")
    if not file then
        return false, "Could not open file"
    end
    
    file:write(data)
    file:close()
    return true
end

-- Write with buffering
print("\n=== Buffered Writing ===")

local function bufferedWrite(filename, lines, bufferSize)
    local file = io.open(filename, "w")
    if not file then
        return false, "Could not open file"
    end
    
    local buffer = {}
    for i, line in ipairs(lines) do
        table.insert(buffer, line)
        if #buffer >= bufferSize then
            file:write(table.concat(buffer, "\n"), "\n")
            buffer = {}
        end
    end
    
    -- Write remaining
    if #buffer > 0 then
        file:write(table.concat(buffer, "\n"), "\n")
    end
    
    file:close()
    return true
end

-- Write log file
print("\n=== Writing Log File ===")

local function writeLog(filename, level, message)
    local file = io.open(filename, "a")
    if not file then
        return false
    end
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    file:write(string.format("[%s] [%s] %s\n", timestamp, level, message))
    file:close()
    return true
end

writeLog("app.log", "INFO", "Application started")
writeLog("app.log", "ERROR", "An error occurred")

-- Atomic write (write to temp, then rename)
print("\n=== Atomic Write ===")

local function atomicWrite(filename, content)
    local tempFile = filename .. ".tmp"
    
    -- Write to temp file
    local file = io.open(tempFile, "w")
    if not file then
        return false, "Could not create temp file"
    end
    
    file:write(content)
    file:close()
    
    -- Rename temp to actual (atomic on most systems)
    os.remove(filename)
    os.rename(tempFile, filename)
    return true
end

-- Write JSON-like structure (simplified)
print("\n=== Writing Structured Data ===")

local function writeStructured(filename, data, indent)
    indent = indent or 0
    local file = io.open(filename, "w")
    if not file then
        return false
    end
    
    local function writeValue(value, level)
        local prefix = string.rep("  ", level)
        if type(value) == "table" then
            file:write("{\n")
            for k, v in pairs(value) do
                file:write(prefix .. "  " .. k .. " = ")
                writeValue(v, level + 1)
            end
            file:write(prefix .. "}\n")
        else
            file:write(tostring(value) .. "\n")
        end
    end
    
    writeValue(data, indent)
    file:close()
    return true
end

-- Write with error recovery
print("\n=== Write with Recovery ===")

local function robustWrite(filename, content)
    local backup = filename .. ".bak"
    
    -- Backup existing file
    if fileExists(filename) then
        os.rename(filename, backup)
    end
    
    -- Try to write
    local ok, err = safeWriteFile(filename, content)
    
    if not ok then
        -- Restore backup on failure
        if fileExists(backup) then
            os.rename(backup, filename)
        end
        return false, err
    end
    
    -- Remove backup on success
    os.remove(backup)
    return true
end

function fileExists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

print("File writing examples completed")
