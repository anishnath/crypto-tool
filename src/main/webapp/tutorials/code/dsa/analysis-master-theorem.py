# Master Theorem Calculator
# Determines complexity of divide-and-conquer algorithms

def master_theorem(a, b, k):
    """
    Master Theorem for T(n) = aT(n/b) + O(n^k)
    
    Case 1: If a > b^k  → T(n) = O(n^(log_b(a)))
    Case 2: If a = b^k  → T(n) = O(n^k log n)
    Case 3: If a < b^k  → T(n) = O(n^k)
    """
    import math
    
    log_b_a = math.log(a) / math.log(b)
    
    print(f"Analyzing: T(n) = {a}T(n/{b}) + O(n^{k})")
    print(f"\na = {a} (number of subproblems)")
    print(f"b = {b} (subproblem size divisor)")
    print(f"k = {k} (work exponent)")
    print(f"\nlog_b(a) = log_{b}({a}) = {log_b_a:.2f}")
    print(f"b^k = {b}^{k} = {b**k}")
    
    if a > b**k:
        print(f"\n✅ Case 1: a > b^k ({a} > {b**k})")
        print(f"Result: T(n) = O(n^{log_b_a:.2f})")
    elif a == b**k:
        print(f"\n✅ Case 2: a = b^k ({a} = {b**k})")
        print(f"Result: T(n) = O(n^{k} log n)")
    else:
        print(f"\n✅ Case 3: a < b^k ({a} < {b**k})")
        print(f"Result: T(n) = O(n^{k})")

# Example 1: Merge Sort
print("=" * 50)
print("Example 1: Merge Sort")
print("=" * 50)
master_theorem(a=2, b=2, k=1)  # T(n) = 2T(n/2) + O(n)

print("\n" + "=" * 50)
print("Example 2: Binary Search")
print("=" * 50)
master_theorem(a=1, b=2, k=0)  # T(n) = T(n/2) + O(1)

print("\n" + "=" * 50)
print("Example 3: Karatsuba Multiplication")
print("=" * 50)
master_theorem(a=3, b=2, k=1)  # T(n) = 3T(n/2) + O(n)
