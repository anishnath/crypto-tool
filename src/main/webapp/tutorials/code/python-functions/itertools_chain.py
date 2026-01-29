from itertools import chain

# Chain multiple iterables together
list1 = [1, 2, 3]
list2 = [4, 5, 6]
list3 = [7, 8, 9]

chained = chain(list1, list2, list3)
print(f"Chained: {list(chained)}")

# Chain strings
words = chain(['Hello', 'World'], ['Python', 'Rocks'])
print(f"Words: {list(words)}")

# Flatten nested list
nested = [[1, 2], [3, 4], [5, 6]]
flattened = chain.from_iterable(nested)
print(f"Flattened: {list(flattened)}")
