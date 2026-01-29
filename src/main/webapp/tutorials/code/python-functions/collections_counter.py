from collections import Counter

# Count elements in a list
fruits = ['apple', 'banana', 'apple', 'orange', 'banana', 'apple']
counter = Counter(fruits)

print(f"Counter: {counter}")
print(f"Apple count: {counter['apple']}")
print(f"Most common: {counter.most_common(2)}")

# Count characters in a string
text = "hello world"
char_count = Counter(text)
print(f"\nCharacter count: {char_count}")

# Arithmetic operations
c1 = Counter(['a', 'b', 'c', 'a'])
c2 = Counter(['a', 'b', 'd'])
print(f"\nUnion: {c1 + c2}")
print(f"Difference: {c1 - c2}")
