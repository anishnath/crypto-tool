# List Methods: Sorting and Ordering

# 1. sort() - Sort in place (modifies original)
print("=== sort() - In-Place Sorting ===")
numbers = [3, 1, 4, 1, 5, 9, 2, 6]
print(f"Original: {numbers}")

numbers.sort()
print(f"After sort(): {numbers}")

numbers.sort(reverse=True)
print(f"After sort(reverse=True): {numbers}")
print()

# Sorting strings
print("=== Sorting Strings ===")
words = ["banana", "Apple", "cherry", "date"]
print(f"Original: {words}")

words.sort()  # Uppercase comes before lowercase!
print(f"After sort(): {words}")

words.sort(key=str.lower)  # Case-insensitive
print(f"After sort(key=str.lower): {words}")
print()

# 2. sorted() - Returns new sorted list (original unchanged)
print("=== sorted() - Returns New List ===")
original = [3, 1, 4, 1, 5]
print(f"Original: {original}")

new_sorted = sorted(original)
print(f"sorted(original): {new_sorted}")
print(f"Original after sorted(): {original}")  # Unchanged!
print()

# 3. reverse() - Reverse in place
print("=== reverse() - In-Place Reversal ===")
items = ["a", "b", "c", "d"]
print(f"Original: {items}")

items.reverse()
print(f"After reverse(): {items}")
print()

# 4. reversed() - Returns iterator (original unchanged)
print("=== reversed() - Returns Iterator ===")
nums = [1, 2, 3, 4, 5]
print(f"Original: {nums}")

reversed_list = list(reversed(nums))
print(f"list(reversed(nums)): {reversed_list}")
print(f"Original after reversed(): {nums}")  # Unchanged!
print()

# 5. Custom sorting with key
print("=== Custom Sorting with key ===")
students = [
    {"name": "Alice", "grade": 85},
    {"name": "Bob", "grade": 92},
    {"name": "Charlie", "grade": 78}
]

students.sort(key=lambda x: x["grade"])
print("Sorted by grade (ascending):")
for s in students:
    print(f"  {s['name']}: {s['grade']}")
