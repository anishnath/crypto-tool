# Boolean Basics in Python
# Booleans represent True or False values

print("=" * 50)
print("1. Boolean Values")
print("=" * 50)

# Direct assignment
is_active = True
is_deleted = False

print(f"is_active: {is_active}")
print(f"is_deleted: {is_deleted}")
print(f"Type: {type(is_active)}")

print("\n" + "=" * 50)
print("2. Booleans from Comparisons")
print("=" * 50)

age = 25
print(f"age = {age}")
print(f"age > 18: {age > 18}")       # True
print(f"age == 25: {age == 25}")     # True
print(f"age < 20: {age < 20}")       # False
print(f"age != 30: {age != 30}")     # True

print("\n" + "=" * 50)
print("3. Boolean in Conditions")
print("=" * 50)

logged_in = True
has_permission = True

if logged_in:
    print("User is logged in")
else:
    print("Please log in")

if logged_in and has_permission:
    print("Access granted!")

print("\n" + "=" * 50)
print("4. Booleans as Numbers")
print("=" * 50)

# True = 1, False = 0
print(f"True + True = {True + True}")     # 2
print(f"True * 10 = {True * 10}")         # 10
print(f"False + 5 = {False + 5}")         # 5

# Count True values in a list
results = [True, False, True, True, False]
print(f"\nResults: {results}")
print(f"Count of True: {sum(results)}")   # 3

print("\n" + "=" * 50)
print("5. Boolean Type Conversion")
print("=" * 50)

# Using bool() function
print(f"bool(1): {bool(1)}")         # True
print(f"bool(0): {bool(0)}")         # False
print(f"bool('hello'): {bool('hello')}")  # True
print(f"bool(''): {bool('')}")       # False
print(f"bool([1,2]): {bool([1,2])}")     # True
print(f"bool([]): {bool([])}")       # False
