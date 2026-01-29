import re

# Find all matches
txt = "The rain in Spain"
x = re.findall("ai", txt)
print(f"Found {len(x)} matches: {x}")

# Find all words
words = re.findall(r"\w+", txt)
print(f"Words: {words}")

# Find all digits
text = "My phone is 123-456-7890"
digits = re.findall(r"\d+", text)
print(f"Digits: {digits}")
