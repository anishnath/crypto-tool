# RegEx Groups and Capturing

import re

# 1. Basic groups with parentheses
print("=== Basic Groups ===")
text = "John Smith, Jane Doe"
matches = re.findall(r"(\w+) (\w+)", text)
print(f"Name pairs: {matches}")

# With finditer for more details
for match in re.finditer(r"(\w+) (\w+)", text):
    print(f"Full: {match.group(0)}, First: {match.group(1)}, Last: {match.group(2)}")
print()

# 2. Named groups
print("=== Named Groups ===")
pattern = r"(?P<first>\w+) (?P<last>\w+)"
match = re.search(pattern, "John Smith")
if match:
    print(f"First name: {match.group('first')}")
    print(f"Last name: {match.group('last')}")
    print(f"As dict: {match.groupdict()}")
print()

# 3. Non-capturing groups
print("=== Non-Capturing Groups (?:...) ===")
text = "I like cats and dogs"
# Without capturing
print(f"(?:cat|dog)s: {re.findall(r'(?:cat|dog)s', text)}")
# With capturing (returns tuple)
print(f"(cat|dog)s: {re.findall(r'(cat|dog)s', text)}")
print()

# 4. Backreferences
print("=== Backreferences ===")
# Find repeated words
text = "the the quick fox"
match = re.search(r"\b(\w+)\s+\1\b", text)
if match:
    print(f"Repeated word: '{match.group(1)}'")

# HTML tag matching
html = "<b>bold</b> and <i>italic</i>"
tags = re.findall(r"<(\w+)>.*?</\1>", html)
print(f"Matching tags: {tags}")
print()

# 5. Using groups in substitution
print("=== Groups in sub() ===")
text = "John Smith"
# Swap first and last name
result = re.sub(r"(\w+) (\w+)", r"\2, \1", text)
print(f"Swapped: {result}")

# Format phone numbers
phone = "5551234567"
formatted = re.sub(r"(\d{3})(\d{3})(\d{4})", r"(\1) \2-\3", phone)
print(f"Phone: {formatted}")
