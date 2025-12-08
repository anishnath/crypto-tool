# Return vs Print - Understanding the Difference

# 1. Print displays, return sends back
print("=== Print vs Return ===")
def add_print(a, b):
    """Uses print - displays result."""
    print(f"Sum: {a + b}")

def add_return(a, b):
    """Uses return - sends back result."""
    return a + b

print("Calling add_print(3, 5):")
result1 = add_print(3, 5)
print(f"Stored result: {result1}")  # None!
print()

print("Calling add_return(3, 5):")
result2 = add_return(3, 5)
print(f"Stored result: {result2}")  # 8!
print()

# 2. Why return matters
print("=== Why Return Matters ===")
def square_print(n):
    print(n * n)

def square_return(n):
    return n * n

# Can't use print result in calculations
print("With print (can't chain):")
# square_print(3) + 10  # Would be: None + 10 = TypeError!

print("With return (can chain):")
result = square_return(3) + 10
print(f"square(3) + 10 = {result}")
print()

# 3. Chaining and composing
print("=== Chaining Functions ===")
def double(n):
    return n * 2

def increment(n):
    return n + 1

# Compose functions with return values
result = double(increment(double(5)))
print(f"double(increment(double(5))) = {result}")
print(f"Step by step: 5 -> 10 -> 11 -> 22")
print()

# 4. Return for testing
print("=== Return for Testing ===")
def is_even(n):
    return n % 2 == 0

# Easy to test
test_cases = [2, 3, 4, 5]
for num in test_cases:
    result = is_even(num)
    status = "PASS" if result == (num % 2 == 0) else "FAIL"
    print(f"is_even({num}) = {result} [{status}]")
