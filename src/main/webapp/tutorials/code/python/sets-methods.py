# Set Methods: Adding and Removing Elements

# Starting set
fruits = {"apple", "banana", "cherry"}
print(f"Starting set: {fruits}")
print()

# 1. add() - Add single element
print("=== add(element) ===")
fruits.add("orange")
print(f"After add('orange'): {fruits}")

fruits.add("apple")  # Adding existing item - no effect
print(f"After add('apple') again: {fruits}")
print()

# 2. update() - Add multiple elements from any iterable
print("=== update(iterable) ===")
fruits.update(["mango", "grape"])
print(f"After update(['mango', 'grape']): {fruits}")

fruits.update("AB")  # String becomes individual chars
print(f"After update('AB'): {fruits}")
print()

# 3. remove() - Remove element (raises error if not found)
print("=== remove(element) ===")
fruits = {"apple", "banana", "cherry"}
fruits.remove("banana")
print(f"After remove('banana'): {fruits}")
# fruits.remove("kiwi")  # KeyError: 'kiwi'
print()

# 4. discard() - Remove element (NO error if not found)
print("=== discard(element) ===")
fruits = {"apple", "banana", "cherry"}
fruits.discard("banana")
print(f"After discard('banana'): {fruits}")
fruits.discard("kiwi")  # No error!
print(f"After discard('kiwi'): {fruits}")
print()

# 5. pop() - Remove and return arbitrary element
print("=== pop() ===")
fruits = {"apple", "banana", "cherry"}
removed = fruits.pop()
print(f"pop() returned: {removed}")
print(f"Set after pop: {fruits}")
print()

# 6. clear() - Remove all elements
print("=== clear() ===")
fruits = {"apple", "banana", "cherry"}
fruits.clear()
print(f"After clear(): {fruits}")
print()

# 7. copy() - Create shallow copy
print("=== copy() ===")
original = {1, 2, 3}
copied = original.copy()
copied.add(4)
print(f"Original: {original}")
print(f"Copy after add(4): {copied}")
