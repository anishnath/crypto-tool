# The range() Function

# range(stop) - 0 to stop-1
print("=== range(5) ===")
for i in range(5):
    print(i, end=" ")
print()  # 0 1 2 3 4

print()

# range(start, stop) - start to stop-1
print("=== range(2, 7) ===")
for i in range(2, 7):
    print(i, end=" ")
print()  # 2 3 4 5 6

print()

# range(start, stop, step)
print("=== range(0, 10, 2) - Even numbers ===")
for i in range(0, 10, 2):
    print(i, end=" ")
print()  # 0 2 4 6 8

print()

# Counting backwards with negative step
print("=== range(10, 0, -1) - Countdown ===")
for i in range(10, 0, -1):
    print(i, end=" ")
print()  # 10 9 8 7 6 5 4 3 2 1

print()

# Using range with len() for index-based iteration
print("=== Using range(len()) ===")
fruits = ["apple", "banana", "cherry"]
for i in range(len(fruits)):
    print(f"fruits[{i}] = {fruits[i]}")

print()

# Creating a list from range
print("=== Converting range to list ===")
numbers = list(range(1, 6))
print(f"list(range(1, 6)) = {numbers}")

squares = [x**2 for x in range(1, 6)]
print(f"Squares: {squares}")
