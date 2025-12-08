# Writing CSV Files

import csv
import os

# 1. Basic writing with csv.writer
print("=== csv.writer() - Basic ===")
data = [
    ["name", "age", "city"],
    ["Alice", 30, "New York"],
    ["Bob", 25, "Los Angeles"],
    ["Charlie", 35, "Chicago"]
]

with open("output.csv", "w", newline="") as f:
    writer = csv.writer(f)
    for row in data:
        writer.writerow(row)

# Read back
with open("output.csv", "r") as f:
    print(f.read())
print()

# 2. writerows() - write multiple at once
print("=== writerows() - Batch Write ===")
with open("batch.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(data)  # Write all at once

with open("batch.csv", "r") as f:
    print(f.read())
print()

# 3. DictWriter - write from dictionaries
print("=== csv.DictWriter() ===")
employees = [
    {"name": "Alice", "department": "Engineering", "salary": 75000},
    {"name": "Bob", "department": "Marketing", "salary": 65000},
    {"name": "Charlie", "department": "Engineering", "salary": 85000}
]

with open("employees.csv", "w", newline="") as f:
    fieldnames = ["name", "department", "salary"]
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()  # Write column names
    writer.writerows(employees)

with open("employees.csv", "r") as f:
    print(f.read())
print()

# 4. Appending to existing CSV
print("=== Append to CSV ===")
new_employee = {"name": "Diana", "department": "HR", "salary": 70000}

with open("employees.csv", "a", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=["name", "department", "salary"])
    writer.writerow(new_employee)

with open("employees.csv", "r") as f:
    print(f.read())
print()

# 5. Writing with different delimiter
print("=== Custom Delimiter (Tab) ===")
with open("tabbed.tsv", "w", newline="") as f:
    writer = csv.writer(f, delimiter="\t")
    writer.writerows(data)

with open("tabbed.tsv", "r") as f:
    print(f.read())

# Cleanup
for fname in ["output.csv", "batch.csv", "employees.csv", "tabbed.tsv"]:
    os.remove(fname)
print("(Cleaned up CSV files)")
