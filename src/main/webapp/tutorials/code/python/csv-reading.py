# Reading CSV Files

import csv
import os

# Create a sample CSV file first
sample_data = """name,age,city,salary
Alice,30,New York,75000
Bob,25,Los Angeles,65000
Charlie,35,Chicago,85000
Diana,28,Houston,70000"""

with open("employees.csv", "w") as f:
    f.write(sample_data)

# 1. Basic reading with csv.reader
print("=== csv.reader() - Basic ===")
with open("employees.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)  # Each row is a list
print()

# 2. Skip header row
print("=== Skip Header ===")
with open("employees.csv", "r") as f:
    reader = csv.reader(f)
    header = next(reader)  # Get and skip header
    print(f"Header: {header}")
    print("Data:")
    for row in reader:
        print(f"  {row[0]} is {row[1]} years old")
print()

# 3. Using DictReader - rows as dictionaries
print("=== csv.DictReader() ===")
with open("employees.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(f"{row['name']}: ${row['salary']} in {row['city']}")
print()

# 4. DictReader with custom fieldnames
print("=== DictReader with Custom Fields ===")
# CSV without header
no_header = """Alice,30,NY
Bob,25,LA"""
with open("no_header.csv", "w") as f:
    f.write(no_header)

with open("no_header.csv", "r") as f:
    reader = csv.DictReader(f, fieldnames=["name", "age", "city"])
    for row in reader:
        print(row)
print()

# 5. Reading into a list
print("=== Read All into List ===")
with open("employees.csv", "r") as f:
    reader = csv.reader(f)
    all_rows = list(reader)
    print(f"Total rows: {len(all_rows)}")
    print(f"Header: {all_rows[0]}")
    print(f"First data: {all_rows[1]}")
print()

# 6. Reading specific columns
print("=== Extract Specific Columns ===")
with open("employees.csv", "r") as f:
    reader = csv.DictReader(f)
    names = [row['name'] for row in reader]
    print(f"Names: {names}")

# Cleanup
os.remove("employees.csv")
os.remove("no_header.csv")
print("\n(Cleaned up CSV files)")
