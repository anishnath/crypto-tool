import random

# Generate random integer between 1 and 10 (inclusive)
x = random.randint(1, 10)
print(f"Random integer (1-10): {x}")

# Simulate dice roll
dice = random.randint(1, 6)
print(f"Dice roll: {dice}")

# Generate 5 random numbers
print("\n5 random integers (1-100):")
for i in range(5):
    print(random.randint(1, 100))
