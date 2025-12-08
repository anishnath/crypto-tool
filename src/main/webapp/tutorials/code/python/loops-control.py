# Loop Control Statements
# break, continue, and pass

# 1. Break: Exits the loop completely
print("Break Example:")
for i in range(1, 10):
    if i == 5:
        print("Breaking at 5")
        break
    print(i)

# 2. Continue: Skips the current iteration and moves to the next
print("\nContinue Example (Odd numbers):")
for i in range(1, 6):
    if i % 2 == 0:
        continue # Skip even numbers
    print(i)

# 3. Pass: A null operation (placeholder)
print("\nPass Example:")
for i in range(3):
    if i == 1:
        pass # Do nothing
        print("Passed 1")
    else:
        print(i)

# 4. Else with loops
# The else block runs when the loop completes normally (no break)
print("\nLoop Else Example:")
for i in range(3):
    print(i)
else:
    print("Loop finished successfully!")
