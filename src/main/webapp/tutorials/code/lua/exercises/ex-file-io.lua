-- Exercise: File I/O
-- TODO: Complete the following exercises

-- 1. Write a function to read a file and return its contents
local function readFile(filename)
    -- your code here
    -- return content or nil, error
end

-- local content, err = readFile("test.txt")

-- 2. Write a function to write content to a file
local function writeFile(filename, content)
    -- your code here
    -- return true or false, error
end

-- writeFile("output.txt", "Hello, World!")

-- 3. Write a function to append to a file
local function appendToFile(filename, content)
    -- your code here
end

-- appendToFile("log.txt", "New log entry\n")

-- 4. Write a function to read file line by line
local function readLines(filename)
    -- your code here
    -- return array of lines
end

-- local lines = readLines("test.txt")
-- for i, line in ipairs(lines) do
--     print(i, line)
-- end

-- 5. Write a function to write array of lines to file
local function writeLines(filename, lines)
    -- your code here
end

-- writeLines("output.txt", {"Line 1", "Line 2", "Line 3"})

-- 6. Write a function to copy a file
local function copyFile(source, dest)
    -- your code here
    -- read source, write to dest
end

-- copyFile("input.txt", "output.txt")

-- 7. Write a function to check if file exists
local function fileExists(filename)
    -- your code here
    -- return true/false
end

-- print("File exists:", fileExists("test.txt"))

-- 8. Write a function to delete a file
local function deleteFile(filename)
    -- your code here
    -- use os.remove()
end

-- deleteFile("temp.txt")

-- 9. Write a function to write CSV data
local function writeCSV(filename, rows)
    -- your code here
    -- each row is an array of values
end

-- local data = {
--     {"Name", "Age", "City"},
--     {"Alice", "25", "NYC"},
--     {"Bob", "30", "LA"}
-- }
-- writeCSV("data.csv", data)

-- 10. Write a function to read CSV data
local function readCSV(filename)
    -- your code here
    -- return array of arrays
end

-- local data = readCSV("data.csv")

-- 11. Write a logging function
local function writeLog(filename, level, message)
    -- your code here
    -- append log entry with timestamp
end

-- writeLog("app.log", "INFO", "Application started")
-- writeLog("app.log", "ERROR", "An error occurred")

-- 12. Write a function to backup a file
local function backupFile(filename)
    -- your code here
    -- copy filename to filename.bak
end

-- backupFile("important.txt")
