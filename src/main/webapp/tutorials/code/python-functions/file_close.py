
f = open("demofile.txt", "w")
f.write("Hello World")

# Changes are not saved/flushed until closed (usually)
f.close()

# Validate
f = open("demofile.txt", "r")
print(f.read())
f.close()

# Best practice: use 'with' statement
with open("demofile.txt", "r") as f:
    print(f.read())
# File is automatically closed here
