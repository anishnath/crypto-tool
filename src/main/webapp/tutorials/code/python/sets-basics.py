# Python Sets
# Sets are UNORDERED, unindexed collections with NO duplicate members.

# 1. Creating Sets
thisset = {"apple", "banana", "cherry"}
print(f"Set: {thisset}")

# 2. No Duplicates
duplicates = {"apple", "banana", "apple", "cherry"}
print(f"With duplicates removed: {duplicates}")

# 3. Accessing Items
# You cannot access by index! Loop through them or check existence.
print("\nLooping:")
for x in thisset:
    print(x)

print(f"\n'banana' in set? {'banana' in thisset}")

# 4. Adding Items
thisset.add("orange")
print(f"After add: {thisset}")

# 5. Removing Items
thisset.remove("banana") # Raises error if not found
thisset.discard("kiwi")  # No error if not found
print(f"After remove: {thisset}")

# 6. Set Operations
set1 = {"a", "b", "c"}
set2 = {1, 2, 3, "a"}

union_set = set1.union(set2) # or set1 | set2
print(f"\nUnion: {union_set}")

intersection = set1.intersection(set2) # or set1 & set2
print(f"Intersection: {intersection}")

difference = set1.difference(set2) # or set1 - set2
print(f"Difference (set1 - set2): {difference}")
