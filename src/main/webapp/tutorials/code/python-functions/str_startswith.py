
txt = "Hello, welcome to my world."

# Check if starts with "Hello"
x = txt.startswith("Hello")
print(f"'{txt}' starts with 'Hello': {x}")

# Check with tuple
y = txt.startswith(("Hi", "Hello"))
print(f"'{txt}' starts with ('Hi', 'Hello'): {y}")

# Check within range (start, end)
# "welcome" starts at index 7
z = txt.startswith("wel", 7, 20)
print(f"Substring [{7}:{20}] starts with 'wel': {z}")
