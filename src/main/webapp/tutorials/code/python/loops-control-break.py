# The break Statement - Exit the Loop Early

# Basic break - stop at specific value
print("=== Basic Break ===")
for i in range(1, 11):
    if i == 5:
        print(f"Breaking at {i}")
        break
    print(i)
print("Loop ended")

print()

# Search and exit when found
print("=== Search Example ===")
names = ["Alice", "Bob", "Charlie", "Diana", "Eve"]
search_for = "Charlie"

for name in names:
    print(f"Checking: {name}")
    if name == search_for:
        print(f"Found {search_for}!")
        break
else:
    print(f"{search_for} not found")

print()

# Break in while loop
print("=== Break in While Loop ===")
count = 0
while True:  # Infinite loop!
    count += 1
    print(f"Count: {count}")
    if count >= 3:
        print("Breaking out!")
        break

print()

# First match only
print("=== First Even Number ===")
numbers = [1, 3, 5, 8, 9, 10]
for num in numbers:
    if num % 2 == 0:
        print(f"First even number: {num}")
        break
