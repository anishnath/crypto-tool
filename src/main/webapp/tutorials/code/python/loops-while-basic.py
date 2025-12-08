# Basic While Loop

# Count from 1 to 5
print("=== Counting Up ===")
count = 1
while count <= 5:
    print(f"Count: {count}")
    count += 1  # CRITICAL: Must update the counter!

print()

# Countdown from 5 to 1
print("=== Counting Down ===")
n = 5
while n > 0:
    print(n)
    n -= 1
print("Done!")

print()

# While loop with boolean condition
print("=== Boolean Condition ===")
is_running = True
steps = 0

while is_running:
    steps += 1
    print(f"Step {steps}")

    if steps >= 3:
        is_running = False  # Stop the loop

print(f"Total steps: {steps}")

print()

# Sum numbers until a limit
print("=== Sum Until Limit ===")
total = 0
num = 1
limit = 100

while total + num <= limit:
    total += num
    num += 1

print(f"Sum of 1 to {num-1}: {total}")
