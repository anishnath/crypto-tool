
# Setup: Create a file
with open("demofile.txt", "w") as f:
    f.write("Line 1\nLine 2\nLine 3")

# Read one line
f = open("demofile.txt", "r")
print(f.readline()) # Reads Line 1
print(f.readline()) # Reads Line 2
f.close()

# Loop through lines
print("\n--- Looping ---")
f = open("demofile.txt", "r")
for x in f:
  print(x)
f.close()
