# The continue Statement - Skip Current Iteration

# Skip even numbers
print("=== Skip Even Numbers ===")
for i in range(1, 11):
    if i % 2 == 0:
        continue  # Skip to next iteration
    print(i)  # Only prints odd numbers

print()

# Skip specific items
print("=== Skip Specific Items ===")
fruits = ["apple", "banana", "cherry", "date", "elderberry"]
skip = "cherry"

for fruit in fruits:
    if fruit == skip:
        print(f"(skipping {skip})")
        continue
    print(f"Processing: {fruit}")

print()

# Filter while processing
print("=== Filter Invalid Data ===")
data = [10, -5, 20, None, 30, "", 40]

total = 0
valid_count = 0

for item in data:
    # Skip invalid data
    if item is None or item == "" or (isinstance(item, int) and item < 0):
        print(f"Skipping invalid: {item}")
        continue

    total += item
    valid_count += 1
    print(f"Added {item}, running total: {total}")

print(f"Total: {total}, Valid items: {valid_count}")

print()

# Continue in while loop
print("=== Continue in While Loop ===")
i = 0
while i < 5:
    i += 1
    if i == 3:
        print("(skipping 3)")
        continue
    print(f"i = {i}")
