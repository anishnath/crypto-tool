# Practical Nested Loop Examples

# 1. All pairs/combinations
print("=== All Pairs ===")
items = ["A", "B", "C"]
for i in items:
    for j in items:
        if i != j:  # Skip same element
            print(f"({i}, {j})")

print()

# 2. Comparing elements
print("=== Finding Duplicates ===")
numbers = [3, 1, 4, 1, 5, 9, 2, 6, 5]
duplicates = []

for i in range(len(numbers)):
    for j in range(i + 1, len(numbers)):  # Only check forward
        if numbers[i] == numbers[j] and numbers[i] not in duplicates:
            duplicates.append(numbers[i])

print(f"Numbers: {numbers}")
print(f"Duplicates: {duplicates}")

print()

# 3. Grid-based game board
print("=== Tic-Tac-Toe Board ===")
board = [
    ["X", "O", "X"],
    ["O", "X", " "],
    [" ", "O", "X"]
]

for i, row in enumerate(board):
    row_str = " | ".join(row)
    print(f" {row_str} ")
    if i < 2:
        print("-----------")

print()

# 4. Search in nested data
print("=== Search in Nested Data ===")
students = [
    {"name": "Alice", "grades": [85, 90, 78]},
    {"name": "Bob", "grades": [92, 88, 95]},
    {"name": "Charlie", "grades": [70, 75, 80]}
]

print("Student Averages:")
for student in students:
    total = 0
    for grade in student["grades"]:
        total += grade
    avg = total / len(student["grades"])
    print(f"  {student['name']}: {avg:.1f}")
