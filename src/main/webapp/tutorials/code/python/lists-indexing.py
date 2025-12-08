# List Indexing and Accessing Elements

fruits = ["apple", "banana", "cherry", "date", "elderberry"]
print(f"List: {fruits}")
print(f"Indices:  0        1         2        3          4")
print()

# Positive indexing (from start)
print("=== Positive Indexing ===")
print(f"fruits[0] = {fruits[0]}")  # First element
print(f"fruits[1] = {fruits[1]}")  # Second element
print(f"fruits[4] = {fruits[4]}")  # Fifth (last) element

print()

# Negative indexing (from end)
print("=== Negative Indexing ===")
print(f"fruits[-1] = {fruits[-1]}")  # Last element
print(f"fruits[-2] = {fruits[-2]}")  # Second to last
print(f"fruits[-5] = {fruits[-5]}")  # Fifth from end (first)

print()

# Checking if element exists
print("=== Checking Membership ===")
print(f"'banana' in fruits: {'banana' in fruits}")
print(f"'grape' in fruits: {'grape' in fruits}")
print(f"'grape' not in fruits: {'grape' not in fruits}")

print()

# Finding index of element
print("=== Finding Index ===")
print(f"Index of 'cherry': {fruits.index('cherry')}")

# Count occurrences
numbers = [1, 2, 3, 2, 4, 2, 5]
print(f"\nList: {numbers}")
print(f"Count of 2: {numbers.count(2)}")
