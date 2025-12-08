# Basic Logical Operators in Python

# The AND operator - both must be true
print("True and True:", True and True)    # True
print("True and False:", True and False)  # False
print("False and True:", False and True)  # False
print("False and False:", False and False) # False

print()

# The OR operator - at least one must be true
print("True or True:", True or True)      # True
print("True or False:", True or False)    # True
print("False or True:", False or True)    # True
print("False or False:", False or False)  # False

print()

# The NOT operator - inverts the value
print("not True:", not True)   # False
print("not False:", not False) # True

print()

# With comparison expressions
age = 25
has_license = True

print("age >= 18:", age >= 18)
print("age >= 18 and has_license:", age >= 18 and has_license)
