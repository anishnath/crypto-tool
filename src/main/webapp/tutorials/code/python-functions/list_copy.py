
fruits = ['apple', 'banana', 'cherry']

# Create a copy of the list
x = fruits.copy()
print(f"Original: {fruits}")
print(f"Copy: {x}")

# Modifying copy doesn't affect original
x.append("orange")
print(f"Modified Copy: {x}")
print(f"Original: {fruits}")
