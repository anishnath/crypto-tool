# Exercise: Guest List Checker
# Task: Check if names are in the guest list.

guests = ["Alice", "Bob", "Charlie", "David"]
banned_users = ["Eve", "Mallory"]

name_to_check = "Bob"
banned_name = "Eve"

# 1. Check if 'name_to_check' is IN the guests list
is_invited = False # Replace False with your code

# 2. Check if 'banned_name' is IN the banned_users list
is_banned = False # Replace False with your code

# 3. Check if 'name_to_check' is NOT IN the banned_users list
is_safe = False # Replace False with your code

print(f"Is {name_to_check} invited? {is_invited}")
print(f"Is {banned_name} banned? {is_banned}")
print(f"Is {name_to_check} safe? {is_safe}")
