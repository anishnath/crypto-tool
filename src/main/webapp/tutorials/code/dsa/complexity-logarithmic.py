# O(log n) - Logarithmic Time Example
# Binary search - halves the search space each time

def binary_search(arr, target):
    """Binary search with operation counting"""
    left, right = 0, len(arr) - 1
    operations = 0
    
    while left <= right:
        operations += 1
        mid = (left + right) // 2
        
        print(f"Step {operations}: Checking index {mid}, value = {arr[mid]}")
        
        if arr[mid] == target:
            print(f"✅ Found {target} at index {mid}")
            print(f"Total operations: {operations}")
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    print(f"❌ {target} not found")
    print(f"Total operations: {operations}")
    return -1

# Test with sorted array
arr = list(range(1, 101))  # [1, 2, 3, ..., 100]
target = 67

print("O(log n) - Logarithmic Time")
print("=" * 40)
print(f"Searching for {target} in array of {len(arr)} elements\n")

binary_search(arr, target)

import math
print(f"\n✅ Time complexity: O(log n)")
print(f"Max operations for n={len(arr)}: {math.ceil(math.log2(len(arr)))}")
print(f"For n=1,000,000: only ~20 operations!")
