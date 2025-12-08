# For Loops
# Used for iterating over a sequence (list, tuple, dictionary, set, or string).

# 1. Loop through a list
fruits = ["apple", "banana", "cherry"]
print("Fruits:")
for fruit in fruits:
    print(fruit)

# 2. Loop through a string
print("\nLetters in 'Python':")
for char in "Python":
    print(char)

# 3. Using range() function
print("\nRange(5):")
for i in range(5):
    print(i) # Prints 0 to 4

print("\nRange(2, 6):")
for i in range(2, 6):
    print(i) # Prints 2 to 5

print("\nRange(0, 10, 2) - Step 2:")
for i in range(0, 10, 2):
    print(i) # Prints 0, 2, 4, 6, 8

# 4. Using enumerate() to get index and value
print("\nEnumerate:")
for index, fruit in enumerate(fruits):
    print(f"Index {index}: {fruit}")
