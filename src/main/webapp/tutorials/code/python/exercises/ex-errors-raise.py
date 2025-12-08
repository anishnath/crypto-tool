# Exercise: Validation Library
# Task: Create a validation library with custom exceptions.

# Requirements:
# 1. Create a base ValidationError exception
# 2. Create specific exceptions: RequiredFieldError, TypeValidationError, RangeError
# 3. Write a validate_user() function that validates user data
# 4. Chain exceptions properly to preserve context

# 1. Define your custom exceptions here:
class ValidationError(Exception):
    """Base validation error."""
    pass

# Add more exception classes...


# 2. Write the validation function:
def validate_user(data):
    """
    Validate user data dictionary.
    Required fields: username (str), email (str), age (int)
    """
    # Your code here:
    pass


# Test your validation:
test_users = [
    {},
    {'username': 'ab', 'email': 'test@mail.com', 'age': 25},
    {'username': 'alice', 'email': 'noatsign', 'age': 25},
    {'username': 'charlie', 'email': 'charlie@mail.com', 'age': 30},
]

print("=== User Validation Tests ===\n")
for user in test_users:
    try:
        validate_user(user)
        print(f"Valid: {user}")
    except ValidationError as e:
        print(f"Invalid: {type(e).__name__}: {e}")
