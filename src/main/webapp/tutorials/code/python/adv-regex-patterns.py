# Common Regex Patterns

import re

text = "Contact: email@example.com, Phone: (555) 123-4567, Date: 2024-01-15"

# Raw strings prevent backslash issues
print("Using raw strings (r'pattern'):")
pattern = r"\d{4}-\d{2}-\d{2}"  # Date pattern
dates = re.findall(pattern, text)
print("Dates:", dates)

# Common patterns
print("\nCommon regex patterns:")

# \d - digits
print("Digits:", re.findall(r"\d+", text))

# \w - word characters (letters, digits, underscore)
print("Words:", re.findall(r"\w+", text))

# \s - whitespace
spaces = re.findall(r"\s", text)
print(f"Whitespace count: {len(spaces)}")

# . - any character (except newline)
print("Any 3 chars:", re.findall(r"...", "abc123")[:3])  # First 3 matches

# ^ - start of string
print("Start match:", re.findall(r"^Contact", text))

# $ - end of string
print("End match:", re.findall(r"15$", text))

# * - zero or more
print("Zero or more digits:", re.findall(r"\d*", "abc123"))

# + - one or more
print("One or more digits:", re.findall(r"\d+", "abc123"))

# ? - zero or one
print("Optional digits:", re.findall(r"\d?", "abc123"))

# {n,m} - between n and m times
print("2-3 digits:", re.findall(r"\d{2,3}", "12 345 6789"))

# Character classes
print("\nCharacter classes:")
print("Digits:", re.findall(r"[0-9]+", text))
print("Letters:", re.findall(r"[a-zA-Z]+", text))
print("Vowels:", re.findall(r"[aeiou]", text))

# Negation [^...]
print("Non-digits:", re.findall(r"[^0-9\s]+", text)[:5])  # First 5

# Escaping special characters
special_text = "Price: $100.50"
print("\nEscaping special chars:")
print("Dollar amounts:", re.findall(r"\$\d+\.\d+", special_text))





