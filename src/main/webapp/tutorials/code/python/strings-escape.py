# Escape Characters in Python
# Backslash (\) is used to include special characters

print("Common Escape Characters:")
print("=" * 40)

# Newline
print("Line 1\nLine 2\nLine 3")

print("\n" + "=" * 40)
# Tab
print("Tab Example:")
print("Name\tAge\tCity")
print("Alice\t25\tNew York")
print("Bob\t30\tLondon")

print("\n" + "=" * 40)
# Backslash itself
print("Backslash: C:\\Users\\Documents\\file.txt")

print("\n" + "=" * 40)
# Quotes inside strings
print("Single quote: It\'s working!")
print("Double quote: She said \"Hello!\"")

print("\n" + "=" * 40)
# Carriage return (overwrites from beginning)
print("Before\rAfter")  # Shows: After

print("\n" + "=" * 40)
print("Raw Strings (prefix with r):")
# Raw strings - backslash is literal
path = r"C:\Users\Documents\file.txt"
print(f"Raw string: {path}")

# Useful for regex patterns
pattern = r"\d{3}-\d{4}"
print(f"Regex pattern: {pattern}")

print("\n" + "=" * 40)
print("Escape Character Reference:")
print(r"\n  - Newline")
print(r"\t  - Tab")
print(r"\\  - Backslash")
print(r"\'  - Single quote")
print(r'\"  - Double quote')
print(r"\r  - Carriage return")
