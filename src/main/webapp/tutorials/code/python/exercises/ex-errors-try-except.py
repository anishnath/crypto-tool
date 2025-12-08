# Exercise: Safe Calculator
# Task: Create a calculator function that handles all possible errors gracefully.

# Requirements:
# 1. Handle division by zero
# 2. Handle invalid number inputs
# 3. Handle unknown operations
# 4. Return a tuple of (success, result_or_error)

def safe_calculate(a, b, operation):
    """
    Safely perform calculation with full error handling.
    Returns (True, result) on success, (False, error_msg) on failure.
    """
    # Your code here:
    # 1. Convert inputs to numbers (handle ValueError, TypeError)

    # 2. Check if operation is valid

    # 3. Perform operation (handle ZeroDivisionError, OverflowError)

    pass


# Test your function:
print("Testing safe_calculate:")
print(safe_calculate(10, 5, '+'))      # Should succeed
print(safe_calculate(10, 0, '/'))      # Division by zero
print(safe_calculate('abc', 5, '+'))   # Invalid input
