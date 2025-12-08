# String Search Methods in Python
# Methods for finding and counting substrings

text = "Python programming is fun. Python is powerful!"
print(f"Text: '{text}'")
print("=" * 50)

# find() - returns index of first occurrence, -1 if not found
print("find() - returns index or -1:")
print(f"find('Python'):     {text.find('Python')}")      # 0
print(f"find('is'):         {text.find('is')}")          # 19
print(f"find('Java'):       {text.find('Java')}")        # -1 (not found)
print(f"find('Python', 10): {text.find('Python', 10)}")  # 27 (start at index 10)

print("\n" + "=" * 50)
# rfind() - find from right (last occurrence)
print("rfind() - find from right:")
print(f"rfind('Python'):    {text.rfind('Python')}")     # 27

print("\n" + "=" * 50)
# index() - like find() but raises ValueError if not found
print("index() - like find() but raises error:")
print(f"index('Python'):    {text.index('Python')}")
# print(text.index('Java'))  # Would raise ValueError!

print("\n" + "=" * 50)
# count() - count occurrences
print("count() - count occurrences:")
print(f"count('Python'):    {text.count('Python')}")     # 2
print(f"count('is'):        {text.count('is')}")         # 2
print(f"count('o'):         {text.count('o')}")          # 4

print("\n" + "=" * 50)
# startswith() and endswith()
print("startswith() and endswith():")
print(f"startswith('Python'): {text.startswith('Python')}")  # True
print(f"startswith('python'): {text.startswith('python')}")  # False (case-sensitive)
print(f"endswith('!'):        {text.endswith('!')}")         # True
print(f"endswith('.'):        {text.endswith('.')}")         # False

# Check multiple options with tuple
filename = "document.pdf"
print(f"\n'{filename}'.endswith(('.pdf', '.doc')): {filename.endswith(('.pdf', '.doc'))}")

print("\n" + "=" * 50)
print("Practical Example - Finding all occurrences:")
word = "Python"
start = 0
positions = []
while True:
    pos = text.find(word, start)
    if pos == -1:
        break
    positions.append(pos)
    start = pos + 1

print(f"'{word}' found at positions: {positions}")
