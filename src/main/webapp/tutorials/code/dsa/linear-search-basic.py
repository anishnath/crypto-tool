"""
Linear Search - The Detective's Method
Simplest searching algorithm - check every element sequentially
Time: O(n), Space: O(1)
Works on: Any array (sorted or unsorted)
"""

def linear_search(arr, target):
    """
    Basic Linear Search
    Check each element until found or end reached
    """
    print(f"Searching for {target} in {arr}")
    print(f"Array size: {len(arr)}\n")
    
    for i in range(len(arr)):
        print(f"Step {i + 1}: Checking arr[{i}] = {arr[i]}")
        
        if arr[i] == target:
            print(f"  ✓ FOUND at index {i}!")
            print(f"\nTotal comparisons: {i + 1}")
            return i
    
    print(f"  ✗ NOT FOUND")
    print(f"Total comparisons: {len(arr)}")
    return -1

def linear_search_sentinel(arr, target):
    """
    Linear Search with Sentinel Optimization
    Adds target at end to eliminate end-of-array check
    Slightly faster in practice
    """
    print(f"Searching for {target} using Sentinel optimization")
    print(f"Original array: {arr}\n")
    
    n = len(arr)
    last = arr[n - 1]  # Save last element
    arr[n - 1] = target  # Place sentinel
    
    i = 0
    while arr[i] != target:
        i += 1
    
    arr[n - 1] = last  # Restore last element
    
    if i < n - 1 or arr[n - 1] == target:
        print(f"✓ FOUND at index {i}")
        print(f"Comparisons: {i + 1}")
        return i
    else:
        print(f"✗ NOT FOUND")
        print(f"Comparisons: {n}")
        return -1

def linear_search_all_occurrences(arr, target):
    """
    Find ALL occurrences of target
    Useful when duplicates exist
    """
    print(f"Finding ALL occurrences of {target} in {arr}\n")
    
    indices = []
    for i in range(len(arr)):
        if arr[i] == target:
            indices.append(i)
            print(f"Found at index {i}")
    
    if indices:
        print(f"\n✓ Found {len(indices)} occurrence(s) at indices: {indices}")
    else:
        print(f"\n✗ NOT FOUND")
    
    return indices

# Example 1: Basic Linear Search
print("=" * 70)
print("Example 1: Basic Linear Search")
print("=" * 70)
arr1 = [5, 2, 8, 1, 9, 3, 7]
target1 = 9
result1 = linear_search(arr1, target1)

# Example 2: Target not found
print("\n" + "=" * 70)
print("Example 2: Target Not Found (Worst Case)")
print("=" * 70)
arr2 = [1, 3, 5, 7, 9]
target2 = 6
result2 = linear_search(arr2, target2)

# Example 3: Target at beginning (Best Case)
print("\n" + "=" * 70)
print("Example 3: Best Case - Target at Beginning")
print("=" * 70)
arr3 = [7, 2, 8, 1, 9]
target3 = 7
result3 = linear_search(arr3, target3)

# Example 4: Sentinel Optimization
print("\n" + "=" * 70)
print("Example 4: Sentinel Optimization")
print("=" * 70)
arr4 = [5, 2, 8, 1, 9, 3, 7]
target4 = 3
result4 = linear_search_sentinel(arr4.copy(), target4)

# Example 5: Find All Occurrences
print("\n" + "=" * 70)
print("Example 5: Find All Occurrences (Duplicates)")
print("=" * 70)
arr5 = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]
target5 = 5
result5 = linear_search_all_occurrences(arr5, target5)

# Example 6: Works on Unsorted Arrays
print("\n" + "=" * 70)
print("Example 6: Linear Search Works on Unsorted Arrays")
print("=" * 70)
unsorted = [9, 3, 7, 1, 5, 2, 8, 4, 6]
print(f"Unsorted array: {unsorted}")
print(f"Searching for 5...")
result6 = linear_search(unsorted, 5)
print("\n✓ Linear Search doesn't require sorted data!")

# Comparison: Linear vs Binary Search
print("\n" + "=" * 70)
print("Comparison: Linear Search vs Binary Search")
print("=" * 70)

print(f"{'Feature':<25} {'Linear Search':<20} {'Binary Search':<20}")
print("-" * 70)
print(f"{'Time Complexity':<25} {'O(n)':<20} {'O(log n)':<20}")
print(f"{'Best Case':<25} {'O(1) - first':<20} {'O(1) - middle':<20}")
print(f"{'Worst Case':<25} {'O(n) - last/not found':<20} {'O(log n)':<20}")
print(f"{'Space Complexity':<25} {'O(1)':<20} {'O(1) iterative':<20}")
print(f"{'Requires Sorted':<25} {'No ✓':<20} {'Yes':<20}")
print(f"{'Works on Any Array':<25} {'Yes ✓':<20} {'Sorted only':<20}")
print(f"{'Implementation':<25} {'Very simple ✓':<20} {'Medium':<20}")

print("\n" + "=" * 70)
print("Performance Comparison (Array Size vs Comparisons)")
print("=" * 70)

sizes = [10, 100, 1000, 10000, 100000, 1000000]
print(f"{'Size':<12} {'Linear (worst)':<15} {'Binary (worst)':<15} {'Binary Advantage':<15}")
print("-" * 60)

for size in sizes:
    linear_worst = size
    binary_worst = size.bit_length()
    advantage = linear_worst / binary_worst if binary_worst > 0 else 0
    print(f"{size:<12,} {linear_worst:<15,} {binary_worst:<15} {advantage:>13.0f}x faster")

print("\n" + "=" * 70)
print("Key Insights:")
print("=" * 70)
print("✓ Linear Search: O(n) - checks every element")
print("✓ Simple: Easiest search algorithm to implement")
print("✓ Flexible: Works on ANY array (sorted or unsorted)")
print("✓ Best case: O(1) - target is first element")
print("✓ Worst case: O(n) - target is last or not found")
print("✓ Use when: Small arrays or unsorted data")
print("✓ Baseline: Foundation for understanding search algorithms")
print("\nFor large sorted arrays, Binary Search is 50,000x faster!")
print("But Linear Search is the ONLY option for unsorted data!")
