# O(n log n) - Linearithmic Time Example
# Merge sort - efficient sorting algorithm

def merge_sort(arr, depth=0):
    """Merge sort with operation tracking"""
    if len(arr) <= 1:
        return arr, 0
    
    # Divide
    mid = len(arr) // 2
    left, left_ops = merge_sort(arr[:mid], depth + 1)
    right, right_ops = merge_sort(arr[mid:], depth + 1)
    
    # Conquer (merge)
    merged, merge_ops = merge(left, right)
    
    total_ops = left_ops + right_ops + merge_ops
    
    if depth == 0:
        print(f"Total operations: {total_ops}")
    
    return merged, total_ops

def merge(left, right):
    """Merge two sorted arrays"""
    result = []
    i = j = ops = 0
    
    while i < len(left) and j < len(right):
        ops += 1
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    
    result.extend(left[i:])
    result.extend(right[j:])
    
    return result, ops

# Test
arr = [64, 34, 25, 12, 22, 11, 90, 88]

print("O(n log n) - Linearithmic Time")
print("=" * 40)
print(f"Original array: {arr}")
print(f"Array size: {len(arr)}\n")

sorted_arr, operations = merge_sort(arr.copy())

print(f"Sorted array: {sorted_arr}")

import math
expected = len(arr) * math.log2(len(arr))
print(f"\n✅ Time complexity: O(n log n)")
print(f"Expected operations: ~{int(expected)}")
print(f"Actual operations: {operations}")
