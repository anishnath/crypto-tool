# Basic RegEx Functions

import re

text = "The quick brown fox jumps over the lazy dog"

# 1. search() - Find first match anywhere in string
print("=== search() ===")
match = re.search(r"fox", text)
if match:
    print(f"Found: '{match.group()}' at position {match.start()}-{match.end()}")
else:
    print("Not found")
print()

# 2. match() - Match only at the beginning
print("=== match() ===")
result = re.match(r"The", text)
print(f"'The' at start: {result is not None}")

result = re.match(r"fox", text)
print(f"'fox' at start: {result is not None}")  # False!
print()

# 3. findall() - Find all matches, return list
print("=== findall() ===")
vowels = re.findall(r"[aeiou]", text)
print(f"All vowels: {vowels}")
print(f"Count: {len(vowels)}")

words = re.findall(r"\b\w{4}\b", text)  # 4-letter words
print(f"4-letter words: {words}")
print()

# 4. split() - Split string at pattern matches
print("=== split() ===")
parts = re.split(r"\s+", text)  # Split on whitespace
print(f"Words: {parts}")

parts = re.split(r"\s+", text, maxsplit=3)
print(f"First 3 splits: {parts}")
print()

# 5. sub() - Replace matches
print("=== sub() ===")
result = re.sub(r"fox", "cat", text)
print(f"Replace 'fox': {result}")

result = re.sub(r"\s+", "_", text)
print(f"Spaces to underscore: {result}")
