# Python Writing Files
# To write to an existing file, you must add a parameter to the open() function:
# "a" - Append - will append to the end of the file
# "w" - Write - will overwrite any existing content

# 1. Append to File
f = open("demofile2.txt", "a")
f.write("Now the file has more content!")
f.close()

# Verify append
f = open("demofile2.txt", "r")
print("--- After Append ---")
print(f.read())
f.close()

# 2. Overwrite File
f = open("demofile3.txt", "w")
f.write("Woops! I have deleted the content!")
f.close()

# Verify overwrite
f = open("demofile3.txt", "r")
print("\n--- After Overwrite ---")
print(f.read())
f.close()

# 3. Write Multiple Lines
lines = ["\nLine A", "\nLine B", "\nLine C"]
f = open("demofile2.txt", "a")
f.writelines(lines)
f.close()

# Verify writelines
f = open("demofile2.txt", "r")
print("\n--- After Writelines ---")
print(f.read())
f.close()
