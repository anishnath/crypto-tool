# Set Operations: Union, Intersection, Difference

# Two sets for demonstration
A = {1, 2, 3, 4, 5}
B = {4, 5, 6, 7, 8}

print(f"Set A: {A}")
print(f"Set B: {B}")
print()

# 1. UNION - All elements from both sets
print("=== UNION (A | B) ===")
print("Elements in A OR B (or both)")
union_method = A.union(B)
union_operator = A | B
print(f"A.union(B): {union_method}")
print(f"A | B: {union_operator}")
print()

# 2. INTERSECTION - Common elements
print("=== INTERSECTION (A & B) ===")
print("Elements in A AND B")
inter_method = A.intersection(B)
inter_operator = A & B
print(f"A.intersection(B): {inter_method}")
print(f"A & B: {inter_operator}")
print()

# 3. DIFFERENCE - Elements in first but not second
print("=== DIFFERENCE (A - B) ===")
print("Elements in A but NOT in B")
diff_method = A.difference(B)
diff_operator = A - B
print(f"A.difference(B): {diff_method}")
print(f"A - B: {diff_operator}")
print()

print("=== DIFFERENCE (B - A) ===")
print("Elements in B but NOT in A")
print(f"B - A: {B - A}")
print()

# 4. SYMMETRIC DIFFERENCE - Elements in either, but not both
print("=== SYMMETRIC DIFFERENCE (A ^ B) ===")
print("Elements in A OR B, but NOT in both")
sym_diff_method = A.symmetric_difference(B)
sym_diff_operator = A ^ B
print(f"A.symmetric_difference(B): {sym_diff_method}")
print(f"A ^ B: {sym_diff_operator}")
print()

# 5. Subset and Superset
print("=== SUBSET & SUPERSET ===")
X = {1, 2, 3}
Y = {1, 2, 3, 4, 5}
print(f"X = {X}")
print(f"Y = {Y}")
print(f"X.issubset(Y): {X.issubset(Y)}")       # X <= Y
print(f"Y.issuperset(X): {Y.issuperset(X)}")   # Y >= X
print(f"X < Y (proper subset): {X < Y}")
print()

# 6. Disjoint - No common elements
print("=== DISJOINT ===")
P = {1, 2, 3}
Q = {4, 5, 6}
print(f"P = {P}, Q = {Q}")
print(f"P.isdisjoint(Q): {P.isdisjoint(Q)}")
