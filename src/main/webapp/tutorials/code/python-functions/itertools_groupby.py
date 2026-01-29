from itertools import groupby

# Group consecutive items
data = [1, 1, 2, 2, 2, 3, 3, 1, 1]

print("Grouped data:")
for key, group in groupby(data):
    print(f"{key}: {list(group)}")

# Group strings by first letter (must be sorted first!)
words = ['apple', 'apricot', 'banana', 'blueberry', 'cherry', 'coconut']
words.sort()  # Important: groupby needs sorted data

print("\nGrouped by first letter:")
for letter, group in groupby(words, key=lambda x: x[0]):
    print(f"{letter}: {list(group)}")
