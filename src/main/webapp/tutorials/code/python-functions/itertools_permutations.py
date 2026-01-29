from itertools import permutations

# Generate all permutations
items = ['A', 'B', 'C']
perms = permutations(items)

print("All permutations:")
for perm in perms:
    print(perm)

# Permutations of length 2
print("\nPermutations of length 2:")
for perm in permutations(items, 2):
    print(perm)

# Use case: Generate passwords
digits = [1, 2, 3]
print(f"\n3-digit permutations: {list(permutations(digits))}")
