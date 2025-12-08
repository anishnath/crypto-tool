# The Modulus Operator (%) - Returns the remainder

# Basic modulus
print("10 % 3 =", 10 % 3)   # 1 (10 = 3*3 + 1)
print("17 % 5 =", 17 % 5)   # 2 (17 = 5*3 + 2)
print("20 % 4 =", 20 % 4)   # 0 (20 divides evenly)

print()

# Common use: Check if a number is even or odd
number = 42
if number % 2 == 0:
    print(f"{number} is even")
else:
    print(f"{number} is odd")

print()

# Check divisibility
print("Is 15 divisible by 3?", 15 % 3 == 0)  # True
print("Is 15 divisible by 4?", 15 % 4 == 0)  # False

print()

# Cycling through values (0, 1, 2, 0, 1, 2, ...)
for i in range(7):
    print(f"{i} % 3 = {i % 3}")
