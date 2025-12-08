# While Loop with Else Clause

# The else block runs when the condition becomes False
# It does NOT run if the loop is exited via 'break'

print("=== While-Else (Normal Exit) ===")
count = 1
while count <= 3:
    print(f"Count: {count}")
    count += 1
else:
    print("Loop completed normally!")  # This runs!

print()

# Else with break - else does NOT run
print("=== While-Else (Break Exit) ===")
count = 1
while count <= 5:
    print(f"Count: {count}")
    if count == 3:
        print("Breaking early!")
        break
    count += 1
else:
    print("This won't print because we used break")

print()

# Practical example: Search with else
print("=== Search Example ===")
numbers = [1, 3, 5, 7, 9]
target = 7
index = 0

while index < len(numbers):
    if numbers[index] == target:
        print(f"Found {target} at index {index}!")
        break
    index += 1
else:
    print(f"{target} not found in the list")

print()

# Another search - target not found
target = 4
index = 0

while index < len(numbers):
    if numbers[index] == target:
        print(f"Found {target} at index {index}!")
        break
    index += 1
else:
    print(f"{target} not found in the list")  # This runs!
