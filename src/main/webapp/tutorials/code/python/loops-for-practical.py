# Practical For Loop Examples

# 1. Sum of numbers
print("=== Sum of Numbers ===")
numbers = [10, 20, 30, 40, 50]
total = 0
for num in numbers:
    total += num
print(f"Sum of {numbers}: {total}")

print()

# 2. Find maximum value
print("=== Finding Maximum ===")
values = [45, 22, 89, 34, 67]
max_value = values[0]
for value in values:
    if value > max_value:
        max_value = value
print(f"Maximum in {values}: {max_value}")

print()

# 3. Count occurrences
print("=== Counting Occurrences ===")
text = "hello world"
target = "l"
count = 0
for char in text:
    if char == target:
        count += 1
print(f"'{target}' appears {count} times in '{text}'")

print()

# 4. Building a new list
print("=== Building a New List ===")
original = [1, 2, 3, 4, 5]
squared = []
for num in original:
    squared.append(num ** 2)
print(f"Original: {original}")
print(f"Squared:  {squared}")

print()

# 5. Filtering items
print("=== Filtering Items ===")
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
evens = []
for num in numbers:
    if num % 2 == 0:
        evens.append(num)
print(f"All numbers: {numbers}")
print(f"Even numbers: {evens}")

print()

# 6. zip() - Iterate over multiple sequences
print("=== Using zip() ===")
names = ["Alice", "Bob", "Charlie"]
scores = [85, 92, 78]

for name, score in zip(names, scores):
    print(f"{name}: {score} points")
