# Creating Lists in Python

# Empty list
empty_list = []
print(f"Empty list: {empty_list}")

# List with elements
fruits = ["apple", "banana", "cherry"]
numbers = [1, 2, 3, 4, 5]
print(f"Fruits: {fruits}")
print(f"Numbers: {numbers}")

# Mixed data types (Python allows this!)
mixed = [1, "hello", 3.14, True, None]
print(f"Mixed types: {mixed}")

# Using list() constructor
from_string = list("hello")
from_range = list(range(5))
print(f"\nFrom string 'hello': {from_string}")
print(f"From range(5): {from_range}")

# Nested lists (list of lists)
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
print(f"\nMatrix (nested list): {matrix}")

# List with repeated elements
zeros = [0] * 5
pattern = ["a", "b"] * 3
print(f"\n[0] * 5 = {zeros}")
print(f"['a', 'b'] * 3 = {pattern}")

# List properties
print(f"\n--- List Properties ---")
print(f"Length of fruits: {len(fruits)}")
print(f"Type: {type(fruits)}")
print(f"Lists are ordered: fruits[0] always = {fruits[0]}")
print(f"Lists allow duplicates: {[1, 1, 2, 2, 3]}")
