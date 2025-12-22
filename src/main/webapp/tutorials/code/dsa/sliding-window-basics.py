# Sliding Window Technique
# Find optimal subarrays efficiently

print("=== Problem: Maximum Sum Subarray ===")
print("Find the maximum sum of k consecutive elements\n")

def max_sum_naive(arr, k):
    """Naive: Recalculate sum for each window - O(n*k)"""
    n = len(arr)
    max_sum = float('-inf')
    operations = 0
    
    for i in range(n - k + 1):
        window_sum = 0
        for j in range(i, i + k):
            window_sum += arr[j]
            operations += 1
        max_sum = max(max_sum, window_sum)
    
    return max_sum, operations

def max_sum_sliding_window(arr, k):
    """Sliding window: Reuse previous sum - O(n)"""
    n = len(arr)
    
    # Calculate first window
    window_sum = sum(arr[:k])
    max_sum = window_sum
    operations = k
    
    # Slide the window
    for i in range(k, n):
        # Remove left element, add right element
        window_sum = window_sum - arr[i - k] + arr[i]
        max_sum = max(max_sum, window_sum)
        operations += 2  # One subtraction, one addition
    
    return max_sum, operations

# Test
arr = [2, 1, 5, 1, 3, 2, 4, 6, 8]
k = 3

print(f"Array: {arr}")
print(f"Window size: {k}\n")

result, ops = max_sum_naive(arr, k)
print(f"❌ Naive O(n*k): Max sum = {result}, Operations = {ops}")

result, ops = max_sum_sliding_window(arr, k)
print(f"✅ Sliding Window O(n): Max sum = {result}, Operations = {ops}\n")

print("=== The Pattern ===")
print("1. Calculate sum of first window")
print("2. Slide: Remove leftmost, add rightmost")
print("3. Update max/min as you go")
print("4. Result: O(n) instead of O(n*k)!")


print("\n=== Variable Window: Longest Substring ===")
print("Find longest substring with at most k distinct characters\n")

def longest_substring_k_distinct(s, k):
    """Variable-size sliding window"""
    char_count = {}
    left = 0
    max_length = 0
    
    for right in range(len(s)):
        # Expand window
        char_count[s[right]] = char_count.get(s[right], 0) + 1
        
        # Shrink window if too many distinct chars
        while len(char_count) > k:
            char_count[s[left]] -= 1
            if char_count[s[left]] == 0:
                del char_count[s[left]]
            left += 1
        
        # Update max
        max_length = max(max_length, right - left + 1)
    
    return max_length

s = "araaci"
k = 2
result = longest_substring_k_distinct(s, k)
print(f"String: '{s}'")
print(f"Max {k} distinct chars: {result} (substring: 'araa')")
print("✅ Variable window adjusts size dynamically!")
