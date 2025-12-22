# Sliding Window Patterns
# Fixed vs Variable window sizes

print("=== Pattern 1: Fixed Window Size ===")
print("Window size is constant\n")

def max_average_subarray(arr, k):
    """Find subarray with maximum average"""
    window_sum = sum(arr[:k])
    max_sum = window_sum
    
    for i in range(k, len(arr)):
        window_sum = window_sum - arr[i - k] + arr[i]
        max_sum = max(max_sum, window_sum)
    
    return max_sum / k

arr = [1, 12, -5, -6, 50, 3]
k = 4
print(f"Array: {arr}")
print(f"Max average of {k} elements: {max_average_subarray(arr, k):.1f}\n")


print("=== Pattern 2: Variable Window Size ===")
print("Window grows/shrinks based on condition\n")

def min_subarray_sum(arr, target):
    """Smallest subarray with sum >= target"""
    min_length = float('inf')
    window_sum = 0
    left = 0
    
    for right in range(len(arr)):
        window_sum += arr[right]
        
        # Shrink window while condition met
        while window_sum >= target:
            min_length = min(min_length, right - left + 1)
            window_sum -= arr[left]
            left += 1
    
    return min_length if min_length != float('inf') else 0

arr = [2, 3, 1, 2, 4, 3]
target = 7
print(f"Array: {arr}")
print(f"Smallest subarray with sum >= {target}: length {min_subarray_sum(arr, target)}\n")


print("=== Pattern 3: String Window (Character Frequency) ===")
print("Track character counts in window\n")

def longest_substring_without_repeating(s):
    """Longest substring with unique characters"""
    char_index = {}
    left = 0
    max_length = 0
    
    for right in range(len(s)):
        if s[right] in char_index and char_index[s[right]] >= left:
            # Move left past the duplicate
            left = char_index[s[right]] + 1
        
        char_index[s[right]] = right
        max_length = max(max_length, right - left + 1)
    
    return max_length

s = "abcabcbb"
print(f"String: '{s}'")
print(f"Longest unique substring: {longest_substring_without_repeating(s)} ('abc')\n")


print("=== When to Use Sliding Window ===")
print("✅ Finding optimal subarray/substring")
print("✅ Contiguous elements with a condition")
print("✅ Can be fixed or variable size")
print("✅ Always O(n) time!")
