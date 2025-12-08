# Exercise: Access Control
# Task: Determine if a user can access a system based on multiple conditions.

is_admin = False
is_logged_in = True
has_permission = False
is_banned = False

# 1. Allow access if user is logged in AND has permission
can_access_content = False # Replace False with your code

# 2. Allow access if user is admin OR has permission
can_access_settings = False # Replace False with your code

# 3. Allow access if user is NOT banned
can_access_forum = False # Replace False with your code

# 4. Complex check: Allow access if (logged in AND not banned) AND (admin OR has permission)
can_access_dashboard = False # Replace False with your code

print(f"Can access content? {can_access_content}")
print(f"Can access settings? {can_access_settings}")
print(f"Can access forum? {can_access_forum}")
print(f"Can access dashboard? {can_access_dashboard}")
