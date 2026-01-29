
# Create using keyword arguments
d1 = dict(name="John", age=36, country="Norway")
print(f"Keyword args: {d1}")

# Create from list of tuples
d2 = dict([('name', 'Alice'), ('age', 25)])
print(f"List of tuples: {d2}")

# Create from two lists using zip
keys = ['a', 'b', 'c']
values = [1, 2, 3]
d3 = dict(zip(keys, values))
print(f"From lists: {d3}")

# Default dictionary (not using dict() directly but related concept)
# Just standard creation
d4 = dict({'one': 1, 'two': 2})
print(f"From dict literal: {d4}")
