# List Methods: Adding Elements

fruits = ["apple", "banana"]
print(f"Original: {fruits}")
print()

# 1. append() - Add single element to end
print("=== append() - Add to End ===")
fruits.append("cherry")
print(f"After fruits.append('cherry'): {fruits}")

fruits.append(["date", "elderberry"])  # Adds list as single element!
print(f"After appending a list: {fruits}")
print()

# Reset for clarity
fruits = ["apple", "banana", "cherry"]

# 2. insert() - Add at specific index
print("=== insert(index, element) ===")
fruits.insert(0, "apricot")  # Insert at beginning
print(f"After insert(0, 'apricot'): {fruits}")

fruits.insert(2, "blueberry")  # Insert in middle
print(f"After insert(2, 'blueberry'): {fruits}")

fruits.insert(100, "zucchini")  # Index > length adds to end
print(f"After insert(100, 'zucchini'): {fruits}")
print()

# 3. extend() - Add multiple elements
print("=== extend(iterable) ===")
colors = ["red", "green"]
print(f"Original colors: {colors}")

colors.extend(["blue", "yellow"])
print(f"After extend(['blue', 'yellow']): {colors}")

# extend() works with any iterable
colors.extend("AB")  # String becomes ['A', 'B']
print(f"After extend('AB'): {colors}")
print()

# 4. += operator (same as extend)
print("=== += Operator ===")
numbers = [1, 2, 3]
numbers += [4, 5]
print(f"[1,2,3] += [4,5] = {numbers}")
print()

# Key difference: append vs extend
print("=== append() vs extend() ===")
list1 = [1, 2, 3]
list1.append([4, 5])
print(f"append([4, 5]): {list1}")  # [1, 2, 3, [4, 5]]

list2 = [1, 2, 3]
list2.extend([4, 5])
print(f"extend([4, 5]): {list2}")  # [1, 2, 3, 4, 5]
