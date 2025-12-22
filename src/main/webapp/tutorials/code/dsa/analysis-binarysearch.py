# Binary Search - Recurrence Analysis
# T(n) = T(n/2) + O(1)

def binary_search(arr, target, left=0, right=None):
    """
    Binary Search: T(n) = T(n/2) + O(1)
    - Searches one half: T(n/2)
    - Comparison work: O(1)
    """
    if right is None:
        right = len(arr) - 1
    
    if left > right:
        return -1
    
    mid = (left + right) // 2
    print(f"Checking index {mid}, value = {arr[mid]}")
    
    if arr[mid] == target:
        return mid
    elif arr[mid] < target:
        return binary_search(arr, target, mid + 1, right)  # T(n/2)
    else:
        return binary_search(arr, target, left, mid - 1)   # T(n/2)

# Test
arr = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
target = 13

print(f"Searching for {target} in {arr}\n")
result = binary_search(arr, target)

if result != -1:
    print(f"\n✅ Found {target} at index {result}")
else:
    print(f"\n❌ {target} not found")

print("\n📊 Recurrence Relation:")
print("T(n) = T(n/2) + O(1)")
print("\nUsing Master Theorem:")
print("a = 1 (one subproblem)")
print("b = 2 (size is n/2)")
print("f(n) = O(1) (constant work)")
print("\nResult: T(n) = O(log n)")
