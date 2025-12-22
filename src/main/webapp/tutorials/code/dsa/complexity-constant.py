# O(1) - Constant Time Example
# No matter how large the array, accessing by index is always one operation

def get_first_element(arr):
    """Access first element - always takes the same time"""
    return arr[0]

def get_element_at_index(arr, index):
    """Access any element by index - constant time"""
    return arr[index]

# Test with different array sizes
small_array = [1, 2, 3, 4, 5]
large_array = list(range(1, 1000001))  # 1 million elements

print("O(1) - Constant Time")
print("=" * 40)

# Small array
result = get_first_element(small_array)
print(f"First element of 5-element array: {result}")

# Large array - takes the SAME time!
result = get_first_element(large_array)
print(f"First element of 1M-element array: {result}")

# Access by index
result = get_element_at_index(large_array, 500000)
print(f"Element at index 500,000: {result}")

print("\n✅ Time complexity: O(1)")
print("Operations: 1 (regardless of array size)")
