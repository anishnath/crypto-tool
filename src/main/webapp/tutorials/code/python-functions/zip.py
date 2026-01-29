
names = ("John", "Charles", "Mike")
ages = (25, 30, 35)

# Zip two tuples
x = zip(names, ages)

# Convert to list and print
print(list(x))

# Iterating over zipped object
print("\nIterating:")
for name, age in zip(names, ages):
    print(f"Name: {name}, Age: {age}")

# Unzipping
zipped = [('John', 25), ('Charles', 30), ('Mike', 35)]
u_names, u_ages = zip(*zipped)
print(f"\nUnzipped Names: {u_names}")
print(f"Unzipped Ages: {u_ages}")
