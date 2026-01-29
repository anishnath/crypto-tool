
x = {"apple", "banana", "cherry"}
y = {"google", "microsoft", "apple"}

# Return a set that contains all items from both sets
z = x.union(y)

print(f"Union: {z}")

# Duplicates are excluded
print(f"Size of x: {len(x)}")
print(f"Size of y: {len(y)}")
print(f"Size of union: {len(z)}")
