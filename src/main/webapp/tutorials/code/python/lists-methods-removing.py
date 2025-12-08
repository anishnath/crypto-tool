# List Methods: Removing Elements

fruits = ["apple", "banana", "cherry", "banana", "date"]
print(f"Original: {fruits}")
print()

# 1. remove(value) - Remove first occurrence of value
print("=== remove(value) ===")
fruits.remove("banana")  # Removes FIRST banana only
print(f"After remove('banana'): {fruits}")
# Note: fruits.remove("grape") would raise ValueError!
print()

# 2. pop() - Remove and return element by index
print("=== pop([index]) ===")
items = ["a", "b", "c", "d", "e"]
print(f"Original: {items}")

last = items.pop()  # Remove last
print(f"items.pop() returned: '{last}', list: {items}")

first = items.pop(0)  # Remove at index 0
print(f"items.pop(0) returned: '{first}', list: {items}")

middle = items.pop(1)  # Remove at index 1
print(f"items.pop(1) returned: '{middle}', list: {items}")
print()

# 3. del statement - Delete by index or slice
print("=== del statement ===")
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
print(f"Original: {numbers}")

del numbers[0]  # Delete first element
print(f"After del numbers[0]: {numbers}")

del numbers[2:5]  # Delete slice
print(f"After del numbers[2:5]: {numbers}")

del numbers[::2]  # Delete every other element
print(f"After del numbers[::2]: {numbers}")
print()

# 4. clear() - Remove all elements
print("=== clear() ===")
data = [1, 2, 3, 4, 5]
print(f"Before clear: {data}")
data.clear()
print(f"After clear: {data}")
print()

# Comparison table
print("=== Method Comparison ===")
print("remove(x)  - By value, first occurrence only")
print("pop(i)     - By index, returns removed item")
print("del list[i]- By index or slice, no return")
print("clear()    - Removes all elements")
