# Common Array Patterns
# Techniques you'll use frequently

arr = [5, 2, 8, 1, 9, 3, 7]

print("=== Pattern 1: Traversal ===")
print("Forward:")
for i in range(len(arr)):
    print(f"  arr[{i}] = {arr[i]}")

print("\nReverse:")
for i in range(len(arr) - 1, -1, -1):
    print(f"  arr[{i}] = {arr[i]}")

print("\n=== Pattern 2: Find Min/Max ===")
min_val = arr[0]
max_val = arr[0]

for num in arr:
    if num < min_val:
        min_val = num
    if num > max_val:
        max_val = num

print(f"Min: {min_val}, Max: {max_val}")

print("\n=== Pattern 3: Two Pointers (Preview) ===")
# Reverse array in-place using two pointers
temp = arr.copy()
left = 0
right = len(temp) - 1

while left < right:
    # Swap elements
    temp[left], temp[right] = temp[right], temp[left]
    left += 1
    right -= 1

print(f"Original: {arr}")
print(f"Reversed: {temp}")
print("✅ Two pointers = O(n) time, O(1) space")

print("\n=== Pattern 4: Sliding Window (Preview) ===")
# Find maximum sum of 3 consecutive elements
def max_sum_window(arr, k=3):
    """Maximum sum of k consecutive elements"""
    if len(arr) < k:
        return None
    
    # Calculate first window
    window_sum = sum(arr[:k])
    max_sum = window_sum
    
    # Slide the window
    for i in range(k, len(arr)):
        window_sum = window_sum - arr[i - k] + arr[i]
        max_sum = max(max_sum, window_sum)
    
    return max_sum

result = max_sum_window(arr, 3)
print(f"Array: {arr}")
print(f"Max sum of 3 consecutive: {result}")
print("✅ Sliding window = O(n) time")

print("\n=== Key Patterns ===")
print("1. Traversal: Visit each element")
print("2. Two Pointers: Work from both ends")
print("3. Sliding Window: Fixed-size subarray")
print("4. Prefix Sum: Cumulative sums (next lesson)")
