# List of Dictionaries - The Most Common Pattern

# This is how JSON API data usually looks!

# 1. Creating a list of dictionaries
print("=== List of Dictionaries ===")
students = [
    {"name": "Alice", "age": 20, "grades": [85, 90, 78]},
    {"name": "Bob", "age": 22, "grades": [70, 75, 80]},
    {"name": "Charlie", "age": 21, "grades": [95, 92, 98]}
]

print("All students:")
for student in students:
    print(f"  {student['name']}, age {student['age']}")
print()

# 2. Accessing specific items
print("=== Accessing Data ===")
# First student's name
print(f"First student: {students[0]['name']}")

# Second student's first grade
print(f"Bob's first grade: {students[1]['grades'][0]}")

# Last student's grades
print(f"Charlie's grades: {students[2]['grades']}")
print()

# 3. Looping through with enumeration
print("=== Loop with Index ===")
for i, student in enumerate(students):
    avg = sum(student['grades']) / len(student['grades'])
    print(f"{i+1}. {student['name']}: avg grade = {avg:.1f}")
print()

# 4. Finding and filtering
print("=== Finding Students ===")
# Find student by name
target = "Bob"
for student in students:
    if student["name"] == target:
        print(f"Found {target}: {student}")
        break

# Filter: students with avg > 80
high_achievers = [s for s in students if sum(s['grades'])/len(s['grades']) > 80]
print(f"\nHigh achievers (avg > 80):")
for s in high_achievers:
    print(f"  {s['name']}")
print()

# 5. Modifying nested data
print("=== Modifying Data ===")
# Add a grade to Alice
students[0]['grades'].append(92)
print(f"Alice's grades after adding 92: {students[0]['grades']}")

# Update Bob's age
students[1]['age'] = 23
print(f"Bob's new age: {students[1]['age']}")

# Add new student
students.append({"name": "Diana", "age": 19, "grades": [88, 91]})
print(f"Total students now: {len(students)}")
