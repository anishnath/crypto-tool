
with open("demofile.txt", "w") as f:
    f.write("Hello World!")

f = open("demofile.txt", "r")
print(f.readline(5)) # Read 5 bytes

# Get current position
position = f.tell()
print(f"Current Position: {position}")
f.close()
