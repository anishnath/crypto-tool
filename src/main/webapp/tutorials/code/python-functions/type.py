
# Check types of various objects
x = 5
print(f"Type of {x}:", type(x))

y = "Hello"
print(f"Type of '{y}':", type(y))

z = [1, 2, 3]
print(f"Type of {z}:", type(z))

# Type checking comparison
if type(x) is int:
    print("x is an integer")

# Using type() with 3 arguments to create dynamic class
NewClass = type('NewClass', (object,), dict(x=1))
print(NewClass)
print(NewClass.x)
