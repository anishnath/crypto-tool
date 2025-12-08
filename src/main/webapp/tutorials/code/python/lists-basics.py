# Python Lists
# Lists are ordered, mutable collections of items.

# 1. Creating Lists
fruits = ["apple", "banana", "cherry"]
numbers = [1, 5, 7, 9, 3]
mixed = [1, "hello", 3.14, True]

print(f"Fruits: {fruits}")
print(f"Numbers: {numbers}")

# 2. Accessing Items (Indexing)
print(f"\nFirst fruit: {fruits[0]}")
print(f"Last fruit: {fruits[-1]}")

# 3. Slicing Lists [start:end:step]
print(f"\nFirst two fruits: {fruits[0:2]}")
print(f"Numbers reversed: {numbers[::-1]}")

# 4. Modifying Lists (Mutable)
fruits[1] = "blueberry"
print(f"\nModified fruits: {fruits}")

# 5. List Length
print(f"Number of fruits: {len(fruits)}")

# 6. Checking existence
if "apple" in fruits:
    print("Yes, apple is in the fruits list")
