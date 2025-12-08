# Exercise: Debug Helper
# Task: Create a function with proper assertions for debugging.

# Requirements:
# 1. Create a calculate_average function
# 2. Add assertions for internal invariants (not input validation)
# 3. Include helpful messages with actual values
# 4. Add a postcondition to verify the result

def calculate_average(numbers):
    """
    Calculate average of a list of numbers.
    Uses assertions to catch bugs, not validate input.
    """
    # Input validation (NOT assertions - these are user-facing)
    # Your code here: validate that numbers is a list
    # Your code here: validate that list is not empty

    # Calculate sum
    total = sum(numbers)

    # Your code here: add an assertion for internal invariant

    # Calculate average
    n = len(numbers)
    average = total / n

    # Your code here: add a postcondition assertion

    return average


# Test the function
test_cases = [
    [1, 2, 3, 4, 5],
    [10, 20, 30],
    [100],
]

print("=== Calculate Average Tests ===\n")
for numbers in test_cases:
    result = calculate_average(numbers)
    print(f"avg({numbers}) = {result}")
