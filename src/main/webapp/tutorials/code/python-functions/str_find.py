
txt = "Hello, welcome to my world."

# Find "welcome"
x = txt.find("welcome")
print(f"Original: '{txt}'")
print(f"Index of 'welcome': {x}")

# Find first "e"
x = txt.find("e")
print(f"Index of first 'e': {x}")

# Find "e" between index 5 and 10
x = txt.find("e", 5, 10)
print(f"Index of 'e' between 5-10: {x}")

# Determine if string not found (-1)
z = txt.find("z")
print(f"Index of 'z' (not found): {z}")
