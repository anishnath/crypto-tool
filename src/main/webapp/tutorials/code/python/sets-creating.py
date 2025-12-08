# Creating Sets in Python

# 1. Using curly braces {}
print("=== Creating Sets ===")
fruits = {"apple", "banana", "cherry"}
print(f"From braces: {fruits}")
print(f"Type: {type(fruits)}")
print()

# 2. Using set() constructor
print("=== Using set() Constructor ===")
from_list = set([1, 2, 3, 2, 1])  # Duplicates removed!
from_string = set("hello")  # Each character becomes element
from_tuple = set((1, 2, 3))
print(f"From list [1,2,3,2,1]: {from_list}")
print(f"From string 'hello': {from_string}")
print(f"From tuple: {from_tuple}")
print()

# 3. Empty set - MUST use set(), not {}
print("=== Empty Set ===")
empty_set = set()  # Correct way
empty_dict = {}    # This is a dict, not a set!
print(f"set(): {empty_set}, type: {type(empty_set)}")
print(f"{{}}: {empty_dict}, type: {type(empty_dict)}")
print()

# 4. Duplicates are automatically removed
print("=== Automatic Duplicate Removal ===")
numbers = {1, 2, 2, 3, 3, 3, 4, 4, 4, 4}
print(f"Input: {{1, 2, 2, 3, 3, 3, 4, 4, 4, 4}}")
print(f"Result: {numbers}")
print()

# 5. Sets are unordered
print("=== Sets are Unordered ===")
colors = {"red", "green", "blue"}
print(f"Set: {colors}")
print("Order may differ each time you run!")
print()

# 6. Only immutable (hashable) items allowed
print("=== Hashable Items Only ===")
valid_set = {1, "hello", (1, 2), 3.14, True}
print(f"Valid (immutable items): {valid_set}")
# invalid_set = {[1, 2]}  # TypeError: unhashable type: 'list'
print("Cannot add lists, dicts, or other sets as elements!")
print()

# 7. Practical: Remove duplicates from list
print("=== Remove Duplicates from List ===")
my_list = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
unique = list(set(my_list))
print(f"Original list: {my_list}")
print(f"Unique (via set): {unique}")
