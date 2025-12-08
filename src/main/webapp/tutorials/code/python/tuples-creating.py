# Creating Tuples in Python

# 1. Basic tuple with parentheses
fruits = ("apple", "banana", "cherry")
print(f"Basic tuple: {fruits}")
print(f"Type: {type(fruits)}")
print()

# 2. Single item tuple - REQUIRES trailing comma!
print("=== Single Item Tuples ===")
single = ("apple",)  # This is a tuple
not_tuple = ("apple")  # This is just a string!
print(f"With comma: {single}, type: {type(single)}")
print(f"Without comma: {not_tuple}, type: {type(not_tuple)}")
print()

# 3. Tuple without parentheses (tuple packing)
print("=== Tuple Packing ===")
colors = "red", "green", "blue"  # Parentheses optional!
print(f"Packed tuple: {colors}, type: {type(colors)}")
print()

# 4. Empty tuple
print("=== Empty Tuple ===")
empty = ()
also_empty = tuple()
print(f"Empty tuple: {empty}")
print(f"Length: {len(empty)}")
print()

# 5. Using tuple() constructor
print("=== Using tuple() Constructor ===")
from_list = tuple([1, 2, 3])
from_string = tuple("hello")
from_range = tuple(range(5))
print(f"From list: {from_list}")
print(f"From string: {from_string}")
print(f"From range: {from_range}")
print()

# 6. Nested tuples
print("=== Nested Tuples ===")
nested = ((1, 2), (3, 4), (5, 6))
print(f"Nested: {nested}")
print(f"First pair: {nested[0]}")
print(f"First element of first pair: {nested[0][0]}")
print()

# 7. Mixed types
print("=== Mixed Types ===")
mixed = (1, "hello", 3.14, True, [1, 2, 3])
print(f"Mixed tuple: {mixed}")
