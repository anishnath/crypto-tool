# Recursion Basics - Functions Calling Themselves

# 1. The simplest recursive function
print("=== Countdown Example ===")
def countdown(n):
    """Count down from n to 1."""
    if n <= 0:  # Base case: stop at 0
        print("Done!")
        return
    print(n)
    countdown(n - 1)  # Recursive call

countdown(5)
print()

# 2. Understanding the call stack
print("=== Call Stack Visualization ===")
def countdown_verbose(n, depth=0):
    """Show the recursive calls."""
    indent = "  " * depth
    print(f"{indent}countdown({n}) called")

    if n <= 0:
        print(f"{indent}Base case reached, returning")
        return

    countdown_verbose(n - 1, depth + 1)
    print(f"{indent}countdown({n}) returning")

countdown_verbose(3)
print()

# 3. Factorial - classic example
print("=== Factorial ===")
def factorial(n):
    """Calculate n! = n * (n-1) * ... * 1"""
    # Base case
    if n <= 1:
        return 1
    # Recursive case
    return n * factorial(n - 1)

# How it works: factorial(4) = 4 * factorial(3)
#                            = 4 * 3 * factorial(2)
#                            = 4 * 3 * 2 * factorial(1)
#                            = 4 * 3 * 2 * 1 = 24

for i in range(1, 7):
    print(f"{i}! = {factorial(i)}")
print()

# 4. Sum of numbers
print("=== Sum of Numbers ===")
def sum_recursive(n):
    """Calculate 1 + 2 + ... + n"""
    if n <= 0:
        return 0
    return n + sum_recursive(n - 1)

print(f"sum(5) = 1+2+3+4+5 = {sum_recursive(5)}")
print(f"sum(10) = {sum_recursive(10)}")
