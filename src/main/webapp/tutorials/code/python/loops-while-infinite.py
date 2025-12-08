# Infinite Loops and How to Avoid Them

# DANGEROUS: Infinite loop examples (DON'T run as-is!)
print("=== Common Infinite Loop Mistakes ===")
print()

# Mistake 1: Forgetting to update counter
print("Mistake 1: Forgetting to update counter")
print('''
# This runs FOREVER!
count = 1
while count <= 5:
    print(count)
    # Missing: count += 1
''')

# Mistake 2: Wrong comparison
print("Mistake 2: Wrong comparison direction")
print('''
# This runs FOREVER!
n = 10
while n > 0:
    print(n)
    n += 1  # Should be n -= 1
''')

# Mistake 3: Condition always True
print("Mistake 3: Condition never becomes False")
print('''
# This runs FOREVER!
x = 5
while x != 10:
    print(x)
    x += 2  # x is 5, 7, 9, 11, 13... never equals 10!
''')

print()
print("=== Intentional Infinite Loop with Break ===")

# Sometimes infinite loops with break are useful
print("(Simulated - runs only 3 times)")
iteration = 0
while True:  # Infinite loop!
    iteration += 1
    print(f"Iteration {iteration}")

    # Condition to break out
    if iteration >= 3:
        print("Breaking out of infinite loop")
        break

print()

# Safe pattern: Always have a failsafe
print("=== Safe Infinite Loop Pattern ===")
max_iterations = 100  # Failsafe
iteration = 0

while True:
    iteration += 1

    # Your actual exit condition
    if iteration >= 3:
        print("Normal exit condition met")
        break

    # Failsafe to prevent truly infinite loop
    if iteration >= max_iterations:
        print("Failsafe triggered!")
        break

    print(f"Working... iteration {iteration}")
