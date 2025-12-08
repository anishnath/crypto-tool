# Python CSV Files
import csv

# Data to write
data = [
    ['Name', 'Age', 'City'],
    ['Alice', '30', 'New York'],
    ['Bob', '25', 'Los Angeles'],
    ['Charlie', '35', 'Chicago']
]

# 1. Writing CSV
print("--- Writing CSV ---")
with open('people.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(data)
print("people.csv created.")

# 2. Reading CSV
print("\n--- Reading CSV ---")
with open('people.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        print(row)

# 3. Reading CSV as Dictionary
print("\n--- Reading CSV as Dict ---")
with open('people.csv', 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        print(dict(row))
