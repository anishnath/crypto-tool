# Exercise: Bitwise Flags
# Task: Use bitwise operators to manage permission flags.

READ_PERMISSION = 4   # Binary: 100
WRITE_PERMISSION = 2  # Binary: 010
EXECUTE_PERMISSION = 1 # Binary: 001

user_permissions = 0

# 1. Grant READ and WRITE permissions using bitwise OR (|)
# user_permissions = ...
user_permissions = user_permissions | READ_PERMISSION | WRITE_PERMISSION

print(f"Permissions (Decimal): {user_permissions}")
print(f"Permissions (Binary): {bin(user_permissions)}")

# 2. Check if user has WRITE permission using bitwise AND (&)
# Result should be non-zero if permission exists
has_write = user_permissions & WRITE_PERMISSION
print(f"Has write permission: {has_write > 0}")

# 3. Revoke WRITE permission using bitwise AND (&) and NOT (~)
# Hint: user_permissions & ~WRITE_PERMISSION
user_permissions = user_permissions & ~WRITE_PERMISSION

print(f"Permissions after revoke (Binary): {bin(user_permissions)}")

# 4. Toggle EXECUTE permission using bitwise XOR (^)
user_permissions = user_permissions ^ EXECUTE_PERMISSION

print(f"Permissions after toggle (Binary): {bin(user_permissions)}")
