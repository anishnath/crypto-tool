# String Operations in Python
# Concatenation, repetition, and membership

print("=" * 40)
print("1. Concatenation (joining strings)")
print("=" * 40)

first_name = "John"
last_name = "Doe"

# Using + operator
full_name = first_name + " " + last_name
print(f"Full name: {full_name}")

# Concatenating multiple strings
greeting = "Hello" + ", " + "World" + "!"
print(f"Greeting: {greeting}")

# Note: Can only concatenate strings
# age = 25
# print("Age: " + age)  # ERROR! Must convert: str(age)
age = 25
print("Age: " + str(age))

print("\n" + "=" * 40)
print("2. Repetition (* operator)")
print("=" * 40)

# Repeat a string
line = "-" * 20
print(f"Line: {line}")

echo = "Hello! " * 3
print(f"Echo: {echo}")

# Creating patterns
pattern = "=-" * 10 + "="
print(f"Pattern: {pattern}")

print("\n" + "=" * 40)
print("3. Membership (in / not in)")
print("=" * 40)

sentence = "Python is a powerful programming language"

# Check if substring exists
print(f"'Python' in sentence: {'Python' in sentence}")
print(f"'Java' in sentence: {'Java' in sentence}")
print(f"'powerful' in sentence: {'powerful' in sentence}")
print(f"'PYTHON' in sentence: {'PYTHON' in sentence}")  # Case sensitive!

# not in
print(f"'Ruby' not in sentence: {'Ruby' not in sentence}")

print("\n" + "=" * 40)
print("4. Practical Example")
print("=" * 40)

# Email validation (basic)
email = "user@example.com"
if "@" in email and "." in email:
    print(f"'{email}' looks like a valid email")
else:
    print(f"'{email}' is not a valid email")

# Building a box
width = 30
print("+" + "-" * (width - 2) + "+")
print("|" + " Welcome! ".center(width - 2) + "|")
print("+" + "-" * (width - 2) + "+")
