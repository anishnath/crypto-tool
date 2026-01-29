import math

# Calculate factorial
x = math.factorial(5)
print(f"5! = {x}")

# Factorial of 0 is 1
y = math.factorial(0)
print(f"0! = {y}")

# Calculate combinations: C(n,r) = n! / (r! * (n-r)!)
n = 5
r = 2
combinations = math.factorial(n) // (math.factorial(r) * math.factorial(n - r))
print(f"C(5,2) = {combinations}")
