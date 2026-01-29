
txt = "Hello, welcome to my world."

# Check if ends with "."
x = txt.endswith(".")
print(f"'{txt}' ends with '.': {x}")

# Check with tuple
y = txt.endswith((".", "!"))
print(f"'{txt}' ends with ('.', '!'): {y}")

# Check within range
# "my world" end at the end of string
z = txt.endswith("my world.", 5, 100)
print(f"Substring [{5}:{100}] ends with 'my world.': {z}")
