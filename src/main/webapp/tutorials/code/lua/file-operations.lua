-- File Operations in Lua

-- Various file operations using io and os libraries

print("=== File Existence Check ===")

local function fileExists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

print("test.txt exists:", fileExists("test.txt"))

-- Get file size
print("\n=== File Size ===")

local function getFileSize(filename)
    local file = io.open(filename, "r")
    if not file then
        return nil, "File not found"
    end
    
    local size = file:seek("end")
    file:close()
    return size
end

-- Copy file
print("\n=== Copy File ===")

local function copyFile(source, dest)
    local sourceFile = io.open(source, "rb")
    if not sourceFile then
        return false, "Could not open source file"
    end
    
    local content = sourceFile:read("*all")
    sourceFile:close()
    
    local destFile = io.open(dest, "wb")
    if not destFile then
        return false, "Could not create destination file"
    end
    
    destFile:write(content)
    destFile:close()
    return true
end

-- Move/Rename file
print("\n=== Move/Rename File ===")

local function moveFile(source, dest)
    local ok, err = os.rename(source, dest)
    if ok then
        return true
    else
        return false, err
    end
end

-- Delete file
print("\n=== Delete File ===")

local function deleteFile(filename)
    local ok, err = os.remove(filename)
    if ok then
        return true
    else
        return false, err
    end
end

-- Create directory (platform-specific)
print("\n=== Create Directory ===")

local function createDirectory(dirname)
    -- Platform-specific
    local ok = os.execute("mkdir " .. dirname)
    return ok == 0 or ok == true
end

-- List directory contents (requires lfs or similar)
print("\n=== Directory Operations ===")

-- Note: Standard Lua doesn't have directory listing
-- Would need LuaFileSystem (lfs) or similar library

-- Get file modification time
print("\n=== File Modification Time ===")

local function getModificationTime(filename)
    -- Create temp file to check
    local file = io.open(filename, "r")
    if not file then
        return nil, "File not found"
    end
    file:close()
    
    -- Use os.execute to get file stats (platform-specific)
    -- This is a simplified example
    return os.time()  -- Would need platform-specific code
end

-- Read file in chunks
print("\n=== Read File in Chunks ===")

local function readFileInChunks(filename, chunkSize, callback)
    local file = io.open(filename, "rb")
    if not file then
        return false, "Could not open file"
    end
    
    while true do
        local chunk = file:read(chunkSize)
        if not chunk then break end
        callback(chunk)
    end
    
    file:close()
    return true
end

-- Usage:
-- readFileInChunks("large.txt", 1024, function(chunk)
--     print("Read", #chunk, "bytes")
-- end)

-- Temporary file creation
print("\n=== Temporary File ===")

local function createTempFile()
    local tempName = os.tmpname()
    local file = io.open(tempName, "w+")
    return file, tempName
end

-- File locking (simplified, not true locking)
print("\n=== File Locking ===")

local function tryLockFile(filename)
    local lockFile = filename .. ".lock"
    
    if fileExists(lockFile) then
        return false, "File is locked"
    end
    
    local file = io.open(lockFile, "w")
    if not file then
        return false, "Could not create lock"
    end
    
    file:write(tostring(os.time()))
    file:close()
    return true
end

local function unlockFile(filename)
    local lockFile = filename .. ".lock"
    return os.remove(lockFile)
end

-- Safe file operations with cleanup
print("\n=== Safe Operations ===")

local function safeFileOperation(filename, operation)
    local ok, result = pcall(operation, filename)
    if ok then
        return result
    else
        return nil, result
    end
end

-- Backup file
print("\n=== Backup File ===")

local function backupFile(filename)
    if not fileExists(filename) then
        return false, "File does not exist"
    end
    
    local backup = filename .. ".bak"
    return copyFile(filename, backup)
end

-- Restore from backup
print("\n=== Restore Backup ===")

local function restoreBackup(filename)
    local backup = filename .. ".bak"
    if not fileExists(backup) then
        return false, "Backup does not exist"
    end
    
    return moveFile(backup, filename)
end

-- File comparison
print("\n=== Compare Files ===")

local function compareFiles(file1, file2)
    local f1 = io.open(file1, "rb")
    local f2 = io.open(file2, "rb")
    
    if not f1 or not f2 then
        if f1 then f1:close() end
        if f2 then f2:close() end
        return false, "Could not open files"
    end
    
    local content1 = f1:read("*all")
    local content2 = f2:read("*all")
    
    f1:close()
    f2:close()
    
    return content1 == content2
end

-- Get file extension
print("\n=== File Extension ===")

local function getFileExtension(filename)
    return filename:match("%.([^%.]+)$")
end

print("Extension of 'test.txt':", getFileExtension("test.txt"))
print("Extension of 'image.png':", getFileExtension("image.png"))

-- Get filename without extension
print("\n=== Filename Without Extension ===")

local function getBaseName(filename)
    return filename:match("(.+)%.[^%.]+$") or filename
end

print("Base name of 'test.txt':", getBaseName("test.txt"))

-- Join path components
print("\n=== Path Operations ===")

local function joinPath(...)
    local parts = {...}
    return table.concat(parts, "/")  -- Unix-style, use \\ for Windows
end

print("Joined path:", joinPath("home", "user", "documents", "file.txt"))

-- Execute system command
print("\n=== System Commands ===")

local function executeCommand(cmd)
    local handle = io.popen(cmd)
    if not handle then
        return nil, "Could not execute command"
    end
    
    local result = handle:read("*all")
    handle:close()
    return result
end

-- Example (platform-specific):
-- local result = executeCommand("ls -l")
-- print(result)

print("File operations examples completed")
