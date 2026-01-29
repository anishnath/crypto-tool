from collections import defaultdict

# Regular dict would raise KeyError
# defaultdict provides default value
dd = defaultdict(int)  # default value is 0

# Count word frequency
words = ['apple', 'banana', 'apple', 'cherry', 'banana', 'apple']
for word in words:
    dd[word] += 1  # No KeyError even on first access

print(f"Word count: {dict(dd)}")

# Group items by length
dd_list = defaultdict(list)
words2 = ['cat', 'dog', 'bird', 'fish', 'elephant']
for word in words2:
    dd_list[len(word)].append(word)

print(f"\nGrouped by length: {dict(dd_list)}")
