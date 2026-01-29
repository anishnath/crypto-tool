
fruits = ['apple', 'banana', 'cherry', 'banana']

# Remove first occurrence of "banana"
fruits.remove("banana")
print(f"Removed 'banana': {fruits}")

# Removing an element usually requires checking if it exists to avoid errors
if "orange" in fruits:
    fruits.remove("orange")
else:
    print("'orange' not in list")
