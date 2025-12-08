# Ternary Operator (Conditional Expressions)
# A concise way to write if-else statements in a single line.

age = 20

# Standard if-else
if age >= 18:
    status = "Adult"
else:
    status = "Minor"
print(f"Status (Standard): {status}")

# Ternary Operator
# Format: value_if_true if condition else value_if_false
status_ternary = "Adult" if age >= 18 else "Minor"
print(f"Status (Ternary): {status_ternary}")

# Example 2: Assigning values
x = 10
y = 20
max_val = x if x > y else y
print(f"Max value: {max_val}")

# Example 3: Inside a function call
is_logged_in = True
print("Welcome back!" if is_logged_in else "Please log in.")
