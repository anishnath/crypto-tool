
# Open a file for writing. Creates the file if it doesn't exist.
f = open("demofile.txt", "w")
f.write("Hello World!")
f.close()

# Open the file for reading
f = open("demofile.txt", "r")
print(f.read())
f.close()

# 'w' - Write - Opens a file for writing, creates the file if it does not exist
# 'r' - Read - Default value. Opens a file for reading, error if the file does not exist
# 'a' - Append - Opens a file for appending, creates the file if it does not exist
# 'x' - Create - Creates the specified file, returns an error if the file exists
