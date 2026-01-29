import random

# Choose random element from list
fruits = ["apple", "banana", "cherry", "date"]
x = random.choice(fruits)
print(f"Random fruit: {x}")

# Choose from string
letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
random_letter = random.choice(letters)
print(f"Random letter: {random_letter}")

# Pick 3 random fruits
print("\n3 random picks:")
for i in range(3):
    print(random.choice(fruits))
