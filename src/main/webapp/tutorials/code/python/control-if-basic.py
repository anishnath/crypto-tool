# Basic if Statement

# Simple if - executes code when condition is True
age = 20

print(f"Age: {age}")
print()

if age >= 18:
    print("You are an adult!")
    print("You can vote.")
    print("You can drive.")

print()

# The code below always runs (not indented under if)
print("This always prints, regardless of age.")

print()

# Multiple conditions with logical operators
has_license = True
has_car = True

print(f"Has license: {has_license}")
print(f"Has car: {has_car}")
print()

if age >= 18 and has_license and has_car:
    print("You can drive legally!")

# Using 'or' for alternative conditions
is_student = False
is_senior = True

if is_student or is_senior:
    print("You qualify for a discount!")
