# Creating Strings in Python
# Strings can be defined using single, double, or triple quotes

# Single quotes
name = 'Alice'
print(f"Single quotes: {name}")

# Double quotes - same as single quotes
greeting = "Hello, World!"
print(f"Double quotes: {greeting}")

# Double quotes allow single quotes inside
message = "It's a beautiful day"
print(f"Single quote inside: {message}")

# Single quotes allow double quotes inside
quote = 'She said "Hello!"'
print(f"Double quote inside: {quote}")

print("\n" + "=" * 40)
print("Triple Quotes (Multiline Strings):")

# Triple quotes for multiline strings
poem = """Roses are red,
Violets are blue,
Python is awesome,
And so are you!"""
print(poem)

print("\n" + "=" * 40)
print("String Length:")

text = "Python Programming"
print(f"String: '{text}'")
print(f"Length: {len(text)} characters")

# Empty string
empty = ""
print(f"Empty string length: {len(empty)}")
