# String Modification Methods in Python
# Methods that return modified versions of strings

print("=" * 50)
print("1. replace() - Replace substrings")
print("=" * 50)

text = "Hello World, Hello Python"
print(f"Original: '{text}'")
print(f"replace('Hello', 'Hi'):    '{text.replace('Hello', 'Hi')}'")
print(f"replace('Hello', 'Hi', 1): '{text.replace('Hello', 'Hi', 1)}'")  # Only first

# Practical: Remove characters
messy = "Hello...World..."
clean = messy.replace(".", "")
print(f"Removing dots: '{clean}'")

print("\n" + "=" * 50)
print("2. strip(), lstrip(), rstrip() - Remove whitespace")
print("=" * 50)

padded = "   Hello World   "
print(f"Original: '{padded}'")
print(f"strip():  '{padded.strip()}'")    # Both sides
print(f"lstrip(): '{padded.lstrip()}'")   # Left only
print(f"rstrip(): '{padded.rstrip()}'")   # Right only

# Strip specific characters
text = "###Hello###"
print(f"\n'{text}'.strip('#'): '{text.strip('#')}'")

print("\n" + "=" * 50)
print("3. split() - Split into list")
print("=" * 50)

sentence = "Python is awesome"
words = sentence.split()
print(f"'{sentence}'.split(): {words}")

csv_line = "apple,banana,cherry"
fruits = csv_line.split(",")
print(f"'{csv_line}'.split(','): {fruits}")

# Limit splits
data = "a-b-c-d-e"
print(f"'{data}'.split('-', 2): {data.split('-', 2)}")  # Max 2 splits

# splitlines() for multiline
multiline = "Line 1\nLine 2\nLine 3"
lines = multiline.splitlines()
print(f"splitlines(): {lines}")

print("\n" + "=" * 50)
print("4. join() - Join list into string")
print("=" * 50)

words = ["Python", "is", "fun"]
print(f"Words: {words}")
print(f"' '.join(words):  '{' '.join(words)}'")
print(f"'-'.join(words):  '{'-'.join(words)}'")
print(f"''.join(words):   '{''.join(words)}'")

# Join numbers (must convert to strings first)
numbers = [1, 2, 3, 4, 5]
result = ", ".join(str(n) for n in numbers)
print(f"Numbers joined: '{result}'")

print("\n" + "=" * 50)
print("5. center(), ljust(), rjust() - Padding")
print("=" * 50)

word = "Python"
print(f"'{word}'.center(20):    '{word.center(20)}'")
print(f"'{word}'.center(20, '-'): '{word.center(20, '-')}'")
print(f"'{word}'.ljust(20, '.'):  '{word.ljust(20, '.')}'")
print(f"'{word}'.rjust(20, '.'):  '{word.rjust(20, '.')}'")

# zfill() - pad with zeros
num = "42"
print(f"'{num}'.zfill(5): '{num.zfill(5)}'")
