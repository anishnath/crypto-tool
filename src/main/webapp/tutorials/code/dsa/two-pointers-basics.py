# Two Pointers Technique - The Essential Pattern
# Solve array problems in O(n) instead of O(n²)

print("=== Problem: Two Sum (Sorted Array) ===")
print("Find two numbers that sum to a target\n")

def two_sum_naive(arr, target):
    """Naive approach: Check every pair - O(n²)"""
    n = len(arr)
    comparisons = 0
    
    for i in range(n):
        for j in range(i + 1, n):
            comparisons += 1
            if arr[i] + arr[j] == target:
                return [i, j], comparisons
    return None, comparisons

def two_sum_two_pointers(arr, target):
    """Two pointers: Work from both ends - O(n)"""
    left = 0
    right = len(arr) - 1
    comparisons = 0
    
    while left < right:
        comparisons += 1
        current_sum = arr[left] + arr[right]
        
        if current_sum == target:
            return [left, right], comparisons
        elif current_sum < target:
            left += 1  # Need larger sum
        else:
            right -= 1  # Need smaller sum
    
    return None, comparisons

# Test both approaches
arr = [1, 2, 3, 4, 6, 8, 9, 12, 15]
target = 10

print(f"Array: {arr}")
print(f"Target: {target}\n")

# Naive approach
result, comps = two_sum_naive(arr, target)
print(f"❌ Naive O(n²): Found {arr[result[0]]} + {arr[result[1]]} = {target}")
print(f"   Comparisons: {comps}\n")

# Two pointers
result, comps = two_sum_two_pointers(arr, target)
print(f"✅ Two Pointers O(n): Found {arr[result[0]]} + {arr[result[1]]} = {target}")
print(f"   Comparisons: {comps}\n")

print("=== The Pattern ===")
print("1. Start with left = 0, right = n-1")
print("2. If sum < target: move left pointer right (increase sum)")
print("3. If sum > target: move right pointer left (decrease sum)")
print("4. If sum == target: found it!")
print("\n✅ Only works on SORTED arrays!")
