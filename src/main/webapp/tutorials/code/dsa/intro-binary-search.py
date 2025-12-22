def binary_search(arr, target):
    """Divide and conquer on sorted array"""
    left, right = 0, len(arr) - 1
    comparisons = 0
    
    while left <= right:
        mid = (left + right) // 2
        comparisons += 1
        
        if arr[mid] == target:
            print(f"Found {target} at index {mid} after {comparisons} comparisons")
            return True
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    print(f"{target} not found after {comparisons} comparisons")
    return False

# Test with a sorted array
numbers = [1, 2, 3, 5, 7, 8, 9]  # Must be sorted!
target = 7

binary_search(numbers, target)

# Show the efficiency
import math
print(f"\nFor {len(numbers)} elements, max comparisons: {math.ceil(math.log2(len(numbers)))}")
