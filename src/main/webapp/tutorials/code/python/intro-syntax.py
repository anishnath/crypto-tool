# Python Syntax Basics

# 1. No semicolons needed (unlike JavaScript, Java, C++)
print("No semicolon needed")
print("Each statement on its own line")

# 2. Case sensitivity - these are all different!
name = "Alice"
Name = "Bob"
NAME = "Charlie"
print(name, Name, NAME)

# 3. Indentation preview (we'll cover this more later)
# Python uses indentation to define code blocks
x = 10
if x > 5:
    print("x is greater than 5")  # This line is indented
    print("Still inside the if block")
print("This is outside the if block")  # Not indented

# 4. Python is dynamically typed
message = "Hello"     # message is a string
message = 42          # now message is a number (this is allowed!)
print("message is now:", message)
