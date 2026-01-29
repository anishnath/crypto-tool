from itertools import combinations

# Generate all combinations of length 2
items = ['A', 'B', 'C', 'D']
combos = combinations(items, 2)

print("Combinations of 2:")
for combo in combos:
    print(combo)

# Combinations of 3
print("\nCombinations of 3:")
for combo in combinations(items, 3):
    print(combo)

# Use case: Password combinations
digits = [1, 2, 3, 4]
print(f"\n2-digit combinations: {list(combinations(digits, 2))}")
