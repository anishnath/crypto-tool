
# Open the file in "w" mode means writing to it. 
# This will overwrite any existing content.
f = open("demofile2.txt", "w")
f.write("Now the file has more content!")
f.close()

# Read the result
f = open("demofile2.txt", "r")
print(f.read())
f.close()

# Use "a" to append instead of overwrite
f = open("demofile2.txt", "a")
f.write(" ... and even more!")
f.close()
