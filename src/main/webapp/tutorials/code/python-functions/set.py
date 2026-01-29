
# List to set (removes duplicates)
lst = [1, 2, 2, 3, 3, 3]
s1 = set(lst)
print(f"List {lst} to set: {s1}")

# String to set (unique characters)
s = "Hello World"
s2 = set(s)
print(f"String '{s}' to set: {s2}")

# Tuple to set
tup = (1, 2, 1, 2)
s3 = set(tup)
print(f"Tuple {tup} to set: {s3}")

# Empty set
s4 = set()
print(f"Empty set: {s4}, type: {type(s4)}")
