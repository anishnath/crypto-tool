# Lambda with Built-in Functions

# 1. sorted() with key
print("=== sorted() with Lambda ===")
words = ["banana", "pie", "Washington", "book"]

# Sort by length
by_length = sorted(words, key=lambda w: len(w))
print(f"By length: {by_length}")

# Sort alphabetically (case-insensitive)
by_alpha = sorted(words, key=lambda w: w.lower())
print(f"Alphabetically: {by_alpha}")
print()

# 2. Sorting complex data
print("=== Sorting Complex Data ===")
students = [
    {"name": "Alice", "grade": 88},
    {"name": "Bob", "grade": 95},
    {"name": "Charlie", "grade": 72}
]

# Sort by grade
by_grade = sorted(students, key=lambda s: s["grade"])
print("By grade (ascending):")
for s in by_grade:
    print(f"  {s['name']}: {s['grade']}")

# Sort by grade descending
by_grade_desc = sorted(students, key=lambda s: s["grade"], reverse=True)
print("\nBy grade (descending):")
for s in by_grade_desc:
    print(f"  {s['name']}: {s['grade']}")
print()

# 3. map() - transform every item
print("=== map() with Lambda ===")
numbers = [1, 2, 3, 4, 5]

# Square each number
squares = list(map(lambda x: x ** 2, numbers))
print(f"Squares: {squares}")

# Convert to strings
strings = list(map(lambda x: f"num_{x}", numbers))
print(f"Strings: {strings}")
print()

# 4. filter() - select items
print("=== filter() with Lambda ===")
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Even numbers only
evens = list(filter(lambda x: x % 2 == 0, numbers))
print(f"Evens: {evens}")

# Greater than 5
big = list(filter(lambda x: x > 5, numbers))
print(f"Greater than 5: {big}")
print()

# 5. Combining map and filter
print("=== Combining map() and filter() ===")
# Get squares of even numbers
even_squares = list(map(lambda x: x ** 2, filter(lambda x: x % 2 == 0, numbers)))
print(f"Even squares: {even_squares}")

# Note: list comprehension is often clearer
even_squares_comp = [x ** 2 for x in numbers if x % 2 == 0]
print(f"Same with comprehension: {even_squares_comp}")
