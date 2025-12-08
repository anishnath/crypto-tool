# Dictionary of Lists - Grouping Related Data

# Great for categorizing or grouping items

# 1. Basic dictionary of lists
print("=== Dictionary of Lists ===")
courses = {
    "programming": ["Python", "JavaScript", "Java"],
    "databases": ["MySQL", "MongoDB", "PostgreSQL"],
    "devops": ["Docker", "Kubernetes", "AWS"]
}

print("Available courses:")
for category, items in courses.items():
    print(f"  {category.capitalize()}: {', '.join(items)}")
print()

# 2. Accessing items
print("=== Accessing Items ===")
print(f"All programming courses: {courses['programming']}")
print(f"First database: {courses['databases'][0]}")
print(f"Number of devops tools: {len(courses['devops'])}")
print()

# 3. Adding items
print("=== Adding Items ===")
# Add to existing list
courses["programming"].append("Go")
print(f"Programming after adding Go: {courses['programming']}")

# Add new category
courses["frontend"] = ["React", "Vue", "Angular"]
print(f"New frontend category: {courses['frontend']}")
print()

# 4. Checking and safe access
print("=== Safe Access ===")
# Check if category exists
if "backend" in courses:
    print(courses["backend"])
else:
    print("Backend category not found")

# Use get() with default
mobile = courses.get("mobile", ["Not available"])
print(f"Mobile courses: {mobile}")
print()

# 5. Transforming data
print("=== Transforming Data ===")
# Count items per category
counts = {cat: len(items) for cat, items in courses.items()}
print(f"Items per category: {counts}")

# Flatten all items
all_items = [item for items in courses.values() for item in items]
print(f"All items: {all_items}")
print()

# 6. Aggregating into dict of lists
print("=== Building Dict of Lists ===")
# Group numbers by even/odd
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
grouped = {"even": [], "odd": []}
for n in numbers:
    if n % 2 == 0:
        grouped["even"].append(n)
    else:
        grouped["odd"].append(n)
print(f"Grouped numbers: {grouped}")
