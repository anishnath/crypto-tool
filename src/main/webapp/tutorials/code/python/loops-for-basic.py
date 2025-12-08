# Basic For Loop - Iterating Over Sequences

# Loop through a list
print("=== Looping Through a List ===")
fruits = ["apple", "banana", "cherry", "date"]
for fruit in fruits:
    print(f"I like {fruit}")

print()

# Loop through a string (character by character)
print("=== Looping Through a String ===")
word = "Python"
for char in word:
    print(char, end=" ")
print()  # New line

print()

# Loop through a tuple
print("=== Looping Through a Tuple ===")
colors = ("red", "green", "blue")
for color in colors:
    print(f"Color: {color}")

print()

# Loop through a set (order not guaranteed)
print("=== Looping Through a Set ===")
unique_numbers = {3, 1, 4, 1, 5, 9}
for num in unique_numbers:
    print(num, end=" ")
print()

print()

# Loop through dictionary keys (default)
print("=== Looping Through Dictionary ===")
person = {"name": "Alice", "age": 30, "city": "NYC"}

print("Keys:")
for key in person:
    print(f"  {key}")

print("Values:")
for value in person.values():
    print(f"  {value}")

print("Key-Value pairs:")
for key, value in person.items():
    print(f"  {key}: {value}")
