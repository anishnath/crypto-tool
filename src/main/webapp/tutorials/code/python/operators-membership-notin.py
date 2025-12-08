# The 'not in' Membership Operator

# Basic usage
print("=== Basic 'not in' ===")
allowed_users = ["admin", "moderator", "user"]
print(f"allowed_users = {allowed_users}")

current_user = "guest"
print(f"current_user = '{current_user}'")
print(f"'{current_user}' not in allowed_users: {current_user not in allowed_users}")  # True

print()

# Practical validation example
print("=== Input Validation ===")
valid_choices = ["yes", "no", "maybe"]
user_input = "perhaps"

if user_input not in valid_choices:
    print(f"'{user_input}' is not a valid choice!")
    print(f"Please choose from: {valid_choices}")

print()

# String validation
print("=== String Validation ===")
password = "MyP@ssw0rd"
forbidden_chars = " '\""  # space, single quote, double quote

has_forbidden = False
for char in forbidden_chars:
    if char in password:
        has_forbidden = True
        print(f"Password contains forbidden character: '{char}'")

if not has_forbidden:
    print("Password is valid (no forbidden characters)")

print()

# Filtering a list
print("=== Filtering with 'not in' ===")
all_items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
exclude = [2, 4, 6, 8, 10]

# Keep only items not in exclude list
filtered = [x for x in all_items if x not in exclude]
print(f"All items: {all_items}")
print(f"Exclude: {exclude}")
print(f"Filtered: {filtered}")  # [1, 3, 5, 7, 9]
