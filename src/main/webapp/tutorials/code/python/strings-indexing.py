# String Indexing in Python
# Each character has a position (index) starting from 0

text = "Python"
print(f"String: '{text}'")
print(f"Length: {len(text)}")

print("\n" + "=" * 40)
print("Positive Indexing (left to right, starts at 0):")
print(f"Index 0: '{text[0]}'  (first character)")
print(f"Index 1: '{text[1]}'")
print(f"Index 2: '{text[2]}'")
print(f"Index 3: '{text[3]}'")
print(f"Index 4: '{text[4]}'")
print(f"Index 5: '{text[5]}'  (last character)")

print("\n" + "=" * 40)
print("Negative Indexing (right to left, starts at -1):")
print(f"Index -1: '{text[-1]}'  (last character)")
print(f"Index -2: '{text[-2]}'")
print(f"Index -3: '{text[-3]}'")
print(f"Index -4: '{text[-4]}'")
print(f"Index -5: '{text[-5]}'")
print(f"Index -6: '{text[-6]}'  (first character)")

print("\n" + "=" * 40)
print("Index Visualization:")
print("  P   y   t   h   o   n")
print("  0   1   2   3   4   5   (positive)")
print(" -6  -5  -4  -3  -2  -1   (negative)")

# Practical example
email = "user@example.com"
print(f"\nEmail: '{email}'")
print(f"First character: '{email[0]}'")
print(f"Last character: '{email[-1]}'")
