# Space Complexity: O(1) - In-Place Algorithm
# Uses constant extra space regardless of input size

def reverse_array_inplace(arr):
    """Reverse array in-place - O(1) space"""
    left = 0
    right = len(arr) - 1
    
    while left < right:
        # Swap elements
        arr[left], arr[right] = arr[right], arr[left]
        left += 1
        right -= 1
    
    return arr

def find_max_inplace(arr):
    """Find max without extra array - O(1) space"""
    max_val = arr[0]
    
    for num in arr:
        if num > max_val:
            max_val = num
    
    return max_val

# Test
arr = [64, 34, 25, 12, 22, 11, 90, 88]

print("Space Complexity: O(1) - In-Place")
print("=" * 40)
print(f"Original array: {arr}\n")

# Reverse in-place
arr_copy = arr.copy()
reversed_arr = reverse_array_inplace(arr_copy)
print(f"Reversed (in-place): {reversed_arr}")

# Find max
max_val = find_max_inplace(arr)
print(f"Maximum value: {max_val}")

print("\n✅ Space complexity: O(1)")
print("Only uses a few variables (left, right, max_val)")
print("No extra arrays or data structures created")
print("Space usage doesn't grow with input size!")
