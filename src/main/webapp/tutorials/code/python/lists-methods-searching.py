# List Methods: Searching and Counting

fruits = ["apple", "banana", "cherry", "banana", "date", "banana"]
print(f"List: {fruits}")
print()

# 1. index() - Find position of first occurrence
print("=== index(value) ===")
pos = fruits.index("banana")
print(f"index('banana'): {pos}")  # First banana at index 1

pos = fruits.index("cherry")
print(f"index('cherry'): {pos}")

# index() with start and end
pos = fruits.index("banana", 2)  # Start searching from index 2
print(f"index('banana', 2): {pos}")

# Note: index() raises ValueError if not found!
# fruits.index("grape")  # ValueError: 'grape' is not in list
print()

# 2. count() - Count occurrences
print("=== count(value) ===")
banana_count = fruits.count("banana")
print(f"count('banana'): {banana_count}")

grape_count = fruits.count("grape")
print(f"count('grape'): {grape_count}")  # 0, doesn't exist
print()

# 3. 'in' operator - Check membership
print("=== 'in' Operator ===")
print(f"'apple' in fruits: {'apple' in fruits}")
print(f"'grape' in fruits: {'grape' in fruits}")
print(f"'grape' not in fruits: {'grape' not in fruits}")
print()

# 4. Safe searching pattern
print("=== Safe Search Pattern ===")
search_item = "cherry"

# Method 1: Check with 'in' first
if search_item in fruits:
    position = fruits.index(search_item)
    print(f"Found '{search_item}' at index {position}")
else:
    print(f"'{search_item}' not found")

# Method 2: Try/except
try:
    position = fruits.index("grape")
    print(f"Found 'grape' at index {position}")
except ValueError:
    print("'grape' not found")
print()

# 5. Finding all occurrences
print("=== Finding All Occurrences ===")
item = "banana"
indices = [i for i, x in enumerate(fruits) if x == item]
print(f"All positions of '{item}': {indices}")
