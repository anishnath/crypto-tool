# Tuple Operations and Methods

# Tuples support many list-like operations (but NOT modification)

# 1. Indexing and Slicing
print("=== Indexing and Slicing ===")
fruits = ("apple", "banana", "cherry", "date", "elderberry")
print(f"Tuple: {fruits}")
print(f"First: {fruits[0]}")
print(f"Last: {fruits[-1]}")
print(f"Slice [1:4]: {fruits[1:4]}")
print(f"Reversed: {fruits[::-1]}")
print()

# 2. Membership testing
print("=== Membership Testing ===")
print(f"'banana' in fruits: {'banana' in fruits}")
print(f"'grape' in fruits: {'grape' in fruits}")
print()

# 3. Concatenation (creates new tuple)
print("=== Concatenation ===")
tuple1 = (1, 2, 3)
tuple2 = (4, 5, 6)
combined = tuple1 + tuple2
print(f"{tuple1} + {tuple2} = {combined}")
print()

# 4. Repetition
print("=== Repetition ===")
repeated = ("A", "B") * 3
print(f"('A', 'B') * 3 = {repeated}")
print()

# 5. Tuple methods (only 2!)
print("=== Tuple Methods ===")
numbers = (1, 2, 3, 2, 4, 2, 5)
print(f"Tuple: {numbers}")
print(f"count(2): {numbers.count(2)}")
print(f"index(4): {numbers.index(4)}")
print()

# 6. Built-in functions work with tuples
print("=== Built-in Functions ===")
nums = (5, 2, 8, 1, 9)
print(f"Tuple: {nums}")
print(f"len(): {len(nums)}")
print(f"min(): {min(nums)}")
print(f"max(): {max(nums)}")
print(f"sum(): {sum(nums)}")
print(f"sorted(): {sorted(nums)}")  # Returns a list!
print()

# 7. Converting between list and tuple
print("=== Conversion ===")
my_list = [1, 2, 3]
my_tuple = tuple(my_list)
back_to_list = list(my_tuple)
print(f"List: {my_list}")
print(f"To tuple: {my_tuple}")
print(f"Back to list: {back_to_list}")
