# Looping Through Dictionaries

student = {
    "name": "Alice",
    "age": 20,
    "major": "Computer Science",
    "gpa": 3.8
}
print(f"Student: {student}")
print()

# 1. Loop through keys (default)
print("=== Loop Through Keys ===")
for key in student:
    print(f"  {key}")
print()

# Explicit keys()
print("=== Using .keys() ===")
for key in student.keys():
    print(f"  {key}: {student[key]}")
print()

# 2. Loop through values
print("=== Using .values() ===")
for value in student.values():
    print(f"  {value}")
print()

# 3. Loop through key-value pairs
print("=== Using .items() ===")
for key, value in student.items():
    print(f"  {key}: {value}")
print()

# 4. Enumerate with items
print("=== Enumerate Items ===")
for i, (key, value) in enumerate(student.items()):
    print(f"  {i}. {key} = {value}")
print()

# 5. Filtering while looping
print("=== Filtering Values ===")
scores = {"Alice": 85, "Bob": 72, "Charlie": 91, "Diana": 68}
passing = {k: v for k, v in scores.items() if v >= 75}
print(f"All scores: {scores}")
print(f"Passing (>=75): {passing}")
print()

# 6. Sorted iteration
print("=== Sorted Iteration ===")
# By key
print("Sorted by key:")
for key in sorted(student.keys()):
    print(f"  {key}: {student[key]}")

# By value (need items)
print("\nScores sorted by value:")
for name, score in sorted(scores.items(), key=lambda x: x[1], reverse=True):
    print(f"  {name}: {score}")
print()

# 7. Safe modification during iteration
print("=== Safe Modification ===")
# Never modify dict size while iterating!
# Instead, iterate over a copy or build new dict
original = {"a": 1, "b": 2, "c": 3, "d": 4}
# Remove items where value is even
filtered = {k: v for k, v in original.items() if v % 2 != 0}
print(f"Original: {original}")
print(f"Filtered (odd values): {filtered}")
