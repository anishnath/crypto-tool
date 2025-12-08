# List Comprehensions with If-Else (Ternary)

# Syntax: [true_expr if condition else false_expr for item in iterable]
# Note: if-else goes BEFORE 'for', filtering 'if' goes AFTER

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
print(f"Numbers: {numbers}")
print()

# 1. Basic if-else in comprehension
print("=== If-Else Transformation ===")

# Label as even or odd
labels = ["even" if x % 2 == 0 else "odd" for x in numbers]
print(f"Even/Odd labels: {labels}")

# Replace negatives with 0
mixed = [-2, -1, 0, 1, 2]
non_negative = [x if x >= 0 else 0 for x in mixed]
print(f"Original: {mixed}")
print(f"Non-negative: {non_negative}")
print()

# 2. Conditional transformation
print("=== Conditional Transform ===")

# Double evens, triple odds
transformed = [x * 2 if x % 2 == 0 else x * 3 for x in numbers]
print(f"Double evens, triple odds: {transformed}")

# Grade labels
scores = [95, 82, 67, 78, 90, 55]
grades = ["Pass" if s >= 60 else "Fail" for s in scores]
print(f"Scores: {scores}")
print(f"Grades: {grades}")
print()

# 3. String transformations
print("=== String If-Else ===")
words = ["Hello", "WORLD", "Python", "CODE"]

# Normalize case: lowercase if upper, uppercase if lower
normalized = [w.lower() if w.isupper() else w.upper() for w in words]
print(f"Original: {words}")
print(f"Swapped case: {normalized}")
print()

# 4. Combining if-else with filter
print("=== Combined: Transform + Filter ===")
# Only process positive numbers, double evens, triple odds
nums = [-2, -1, 0, 1, 2, 3, 4, 5]
result = [x * 2 if x % 2 == 0 else x * 3 for x in nums if x > 0]
print(f"Original: {nums}")
print(f"Positive only, double evens/triple odds: {result}")
