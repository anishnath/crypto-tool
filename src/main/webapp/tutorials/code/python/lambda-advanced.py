# Advanced Lambda Patterns

# 1. Lambda with conditional expression
print("=== Conditional Lambdas ===")
# Syntax: lambda x: value_if_true if condition else value_if_false

is_even = lambda x: "even" if x % 2 == 0 else "odd"
print(f"is_even(4) = {is_even(4)}")
print(f"is_even(7) = {is_even(7)}")

abs_val = lambda x: x if x >= 0 else -x
print(f"abs_val(-5) = {abs_val(-5)}")
print(f"abs_val(3) = {abs_val(3)}")
print()

# 2. Higher-order function returning lambda
print("=== Functions Returning Lambdas ===")
def make_multiplier(n):
    """Create a function that multiplies by n."""
    return lambda x: x * n

double = make_multiplier(2)
triple = make_multiplier(3)
times_ten = make_multiplier(10)

print(f"double(5) = {double(5)}")
print(f"triple(5) = {triple(5)}")
print(f"times_ten(5) = {times_ten(5)}")
print()

# 3. Lambda in dictionaries (dispatch pattern)
print("=== Lambda Dispatch ===")
operations = {
    "add": lambda a, b: a + b,
    "subtract": lambda a, b: a - b,
    "multiply": lambda a, b: a * b,
    "divide": lambda a, b: a / b if b != 0 else "Error"
}

a, b = 10, 3
for op_name, op_func in operations.items():
    print(f"{a} {op_name} {b} = {op_func(a, b)}")
print()

# 4. Using lambda with reduce()
print("=== reduce() with Lambda ===")
from functools import reduce

numbers = [1, 2, 3, 4, 5]

# Sum all numbers
total = reduce(lambda acc, x: acc + x, numbers)
print(f"Sum: {total}")

# Find maximum
maximum = reduce(lambda a, b: a if a > b else b, numbers)
print(f"Max: {maximum}")

# Product of all
product = reduce(lambda acc, x: acc * x, numbers)
print(f"Product: {product}")
print()

# 5. min/max with key
print("=== min/max with Lambda ===")
data = [{"name": "A", "value": 10}, {"name": "B", "value": 5}, {"name": "C", "value": 15}]

min_item = min(data, key=lambda x: x["value"])
max_item = max(data, key=lambda x: x["value"])

print(f"Min value: {min_item}")
print(f"Max value: {max_item}")
