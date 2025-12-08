# Modifying Lists - Lists are Mutable!

# Change single element
fruits = ["apple", "banana", "cherry"]
print(f"Original: {fruits}")

fruits[1] = "blueberry"
print(f"After fruits[1] = 'blueberry': {fruits}")

print()

# Change multiple elements with slice assignment
numbers = [1, 2, 3, 4, 5]
print(f"Original: {numbers}")

numbers[1:4] = [20, 30, 40]
print(f"After numbers[1:4] = [20, 30, 40]: {numbers}")

# Replace with different length
numbers[1:4] = [200]  # Replace 3 elements with 1
print(f"After numbers[1:4] = [200]: {numbers}")

print()

# Adding elements
print("=== Adding Elements ===")
fruits = ["apple", "banana"]

fruits.append("cherry")  # Add to end
print(f"After append('cherry'): {fruits}")

fruits.insert(1, "apricot")  # Insert at position
print(f"After insert(1, 'apricot'): {fruits}")

fruits.extend(["date", "elderberry"])  # Add multiple
print(f"After extend(['date', 'elderberry']): {fruits}")

print()

# Removing elements
print("=== Removing Elements ===")
items = ["a", "b", "c", "d", "e"]
print(f"Original: {items}")

items.remove("c")  # Remove by value
print(f"After remove('c'): {items}")

popped = items.pop()  # Remove last
print(f"After pop(): {items}, popped: {popped}")

popped = items.pop(0)  # Remove at index
print(f"After pop(0): {items}, popped: {popped}")

del items[0]  # Delete at index
print(f"After del items[0]: {items}")
