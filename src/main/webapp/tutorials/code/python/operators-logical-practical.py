# Practical Logical Operator Examples

# User authentication scenario
is_logged_in = True
is_admin = False
has_permission = True
account_active = True

# Check if user can access admin panel
can_access_admin = is_logged_in and is_admin
print("Can access admin:", can_access_admin)  # False

# Check if user can edit content
can_edit = is_logged_in and (is_admin or has_permission)
print("Can edit content:", can_edit)  # True

# Check if account is usable
is_usable = is_logged_in and account_active and not is_admin
print("Regular active user:", is_usable)  # True

print()

# Age and membership validation
age = 25
is_member = True
has_parent_consent = False

# Can access adult content
can_access_adult = age >= 18 or has_parent_consent
print("Can access adult content:", can_access_adult)  # True

# Can get member discount
can_get_discount = is_member and age >= 18
print("Can get member discount:", can_get_discount)  # True

print()

# Complex condition with parentheses
# VIP access: (admin OR premium member) AND (not banned) AND (account active)
is_premium = True
is_banned = False

vip_access = (is_admin or is_premium) and (not is_banned) and account_active
print("VIP access:", vip_access)  # True
