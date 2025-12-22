"""
Binary Search - The Dictionary Lookup
Most important searching algorithm!
Time: O(log n), Space: O(1) iterative / O(log n) recursive
Requirement: Array must be SORTED
"""

def binary_search_iterative(arr, target):
    """
    Iterative Binary Search - Recommended approach
    More efficient (no recursion overhead)
    Space: O(1)
    """
    left = 0
    right = len(arr) - 1
    steps = 0
    
    print(f"Searching for {target} in {arr}")
    print(f"Array size: {len(arr)}\n")
    
    while left <= right:
        steps += 1
        # Avoid integer overflow: mid = left + (right - left) // 2
        mid = (left + right) // 2
        
        print(f"Step {steps}:")
        print(f"  Range: [{left}:{right}] (size: {right - left + 1})")
        print(f"  Mid index: {mid}, Mid value: {arr[mid]}")
        
        if arr[mid] == target:
            print(f"  ✓ FOUND at index {mid}!")
            print(f"\nTotal comparisons: {steps}")
            return mid
        elif arr[mid] < target:
            print(f"  {arr[mid]} < {target}, search RIGHT half")
            left = mid + 1
        else:
            print(f"  {arr[mid]} > {target}, search LEFT half")
            right = mid - 1
        print()
    
    print(f"  ✗ NOT FOUND")
    print(f"Total comparisons: {steps}")
    return -1

def binary_search_recursive(arr, target, left=None, right=None, steps=0):
    """
    Recursive Binary Search - Elegant but uses stack space
    Space: O(log n) due to recursion
    """
    if left is None:
        left = 0
        right = len(arr) - 1
        print(f"Searching for {target} in {arr}")
        print(f"Array size: {len(arr)}\n")
    
    if left > right:
        print(f"  ✗ NOT FOUND")
        print(f"Total comparisons: {steps}")
        return -1
    
    steps += 1
    mid = (left + right) // 2
    
    print(f"Step {steps}:")
    print(f"  Range: [{left}:{right}] (size: {right - left + 1})")
    print(f"  Mid index: {mid}, Mid value: {arr[mid]}")
    
    if arr[mid] == target:
        print(f"  ✓ FOUND at index {mid}!")
        print(f"\nTotal comparisons: {steps}")
        return mid
    elif arr[mid] < target:
        print(f"  {arr[mid]} < {target}, search RIGHT half\n")
        return binary_search_recursive(arr, target, mid + 1, right, steps)
    else:
        print(f"  {arr[mid]} > {target}, search LEFT half\n")
        return binary_search_recursive(arr, target, left, mid - 1, steps)

def binary_search_first_occurrence(arr, target):
    """
    Find FIRST occurrence of target
    Useful when array has duplicates
    """
    left, right = 0, len(arr) - 1
    result = -1
    
    print(f"Finding FIRST occurrence of {target} in {arr}\n")
    
    while left <= right:
        mid = (left + right) // 2
        
        if arr[mid] == target:
            result = mid  # Found, but keep searching left
            right = mid - 1
            print(f"Found at {mid}, searching left for first occurrence...")
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    if result != -1:
        print(f"✓ First occurrence at index {result}")
    else:
        print(f"✗ Not found")
    return result

def binary_search_last_occurrence(arr, target):
    """
    Find LAST occurrence of target
    Useful when array has duplicates
    """
    left, right = 0, len(arr) - 1
    result = -1
    
    print(f"Finding LAST occurrence of {target} in {arr}\n")
    
    while left <= right:
        mid = (left + right) // 2
        
        if arr[mid] == target:
            result = mid  # Found, but keep searching right
            left = mid + 1
            print(f"Found at {mid}, searching right for last occurrence...")
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    if result != -1:
        print(f"✓ Last occurrence at index {result}")
    else:
        print(f"✗ Not found")
    return result

# Example 1: Basic Binary Search (Iterative)
print("=" * 70)
print("Example 1: Iterative Binary Search")
print("=" * 70)
arr1 = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
target1 = 7
result1 = binary_search_iterative(arr1, target1)

# Example 2: Recursive Binary Search
print("\n" + "=" * 70)
print("Example 2: Recursive Binary Search")
print("=" * 70)
arr2 = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
target2 = 14
result2 = binary_search_recursive(arr2, target2)

# Example 3: Target not found
print("\n" + "=" * 70)
print("Example 3: Target Not Found")
print("=" * 70)
arr3 = [1, 3, 5, 7, 9]
target3 = 6
result3 = binary_search_iterative(arr3, target3)

# Example 4: Large array (shows power of O(log n))
print("\n" + "=" * 70)
print("Example 4: Large Array (1000 elements)")
print("=" * 70)
arr4 = list(range(1, 1001, 1))  # [1, 2, 3, ..., 1000]
target4 = 789
print(f"Array: [1, 2, 3, ..., 1000] ({len(arr4)} elements)")
print(f"Target: {target4}\n")
result4 = binary_search_iterative(arr4, target4)
print(f"\nNote: Only {10} comparisons for 1000 elements! (vs 789 for linear search)")

# Example 5: First and Last Occurrence
print("\n" + "=" * 70)
print("Example 5: First and Last Occurrence (Duplicates)")
print("=" * 70)
arr5 = [1, 2, 2, 2, 3, 4, 4, 5, 5, 5, 5, 6]
target5 = 5
first = binary_search_first_occurrence(arr5, target5)
print()
last = binary_search_last_occurrence(arr5, target5)
if first != -1:
    print(f"\nOccurrences of {target5}: indices [{first}:{last+1}] = {arr5[first:last+1]}")

# Comparison: Linear vs Binary Search
print("\n" + "=" * 70)
print("Comparison: Linear Search vs Binary Search")
print("=" * 70)

def linear_search(arr, target):
    """Linear search for comparison"""
    for i in range(len(arr)):
        if arr[i] == target:
            return i
    return -1

sizes = [10, 100, 1000, 10000, 100000, 1000000]
print(f"{'Size':<12} {'Linear (worst)':<15} {'Binary (worst)':<15} {'Speedup':<10}")
print("-" * 60)

for size in sizes:
    linear_worst = size
    binary_worst = size.bit_length()  # log2(size) + 1
    speedup = linear_worst / binary_worst if binary_worst > 0 else 0
    print(f"{size:<12,} {linear_worst:<15,} {binary_worst:<15} {speedup:>8.0f}x")

print("\n" + "=" * 70)
print("Key Insights:")
print("=" * 70)
print("✓ Binary Search: O(log n) - logarithmic time")
print("✓ Requires: SORTED array")
print("✓ Best case: O(1) - middle element")
print("✓ Worst case: O(log n) - still very fast!")
print("✓ Space: O(1) iterative, O(log n) recursive")
print("✓ Real-world: Used in databases, libraries, games")
print("✓ Interview: MUST KNOW algorithm!")
print("\nBinary Search is 50,000x faster than Linear for 1M elements!")
