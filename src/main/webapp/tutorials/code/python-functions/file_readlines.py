
# Setup
with open("demofile.txt", "w") as f:
    f.write("Apple\nBanana\nCherry")

# Return all lines as a list
f = open("demofile.txt", "r")
print(f.readlines())
f.close()

# Hint: seek(0) resets the file pointer to the beginning
