# Two Pointers - Common Patterns
# Master these 3 patterns for interviews

print("=== Pattern 1: Opposite Ends (Two Sum) ===")
def two_sum(arr, target):
    """Start from both ends, move based on sum"""
    left, right = 0, len(arr) - 1
    
    while left < right:
        s = arr[left] + arr[right]
        if s == target:
            return [left, right]
        elif s < target:
            left += 1
        else:
            right -= 1
    return None

arr = [1, 2, 3, 4, 6]
print(f"Find two numbers that sum to 7: {two_sum(arr, 7)}")
print("✅ O(n) time, O(1) space\n")


print("=== Pattern 2: Same Direction (Remove Duplicates) ===")
def remove_duplicates(arr):
    """Keep unique elements, return new length"""
    if not arr:
        return 0
    
    write = 1  # Where to write next unique element
    
    for read in range(1, len(arr)):
        if arr[read] != arr[read - 1]:
            arr[write] = arr[read]
            write += 1
    
    return write

arr = [1, 1, 2, 2, 2, 3, 4, 4, 5]
length = remove_duplicates(arr)
print(f"Original: [1, 1, 2, 2, 2, 3, 4, 4, 5]")
print(f"After:    {arr[:length]}")
print("✅ O(n) time, O(1) space (in-place)\n")


print("=== Pattern 3: Sliding Window (Fixed Size) ===")
def max_sum_subarray(arr, k):
    """Maximum sum of k consecutive elements"""
    if len(arr) < k:
        return None
    
    # Initial window
    window_sum = sum(arr[:k])
    max_sum = window_sum
    
    # Slide the window
    for i in range(k, len(arr)):
        window_sum = window_sum - arr[i - k] + arr[i]
        max_sum = max(max_sum, window_sum)
    
    return max_sum

arr = [2, 1, 5, 1, 3, 2]
print(f"Array: {arr}")
print(f"Max sum of 3 consecutive: {max_sum_subarray(arr, 3)}")
print("✅ O(n) time - slides window instead of recalculating\n")


print("=== When to Use Two Pointers ===")
print("✅ Array is sorted (or can be sorted)")
print("✅ Need to find pairs/triplets")
print("✅ Remove duplicates in-place")
print("✅ Reverse/palindrome checks")
print("✅ Partition problems")
