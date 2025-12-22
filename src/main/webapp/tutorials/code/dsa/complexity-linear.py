# O(n) - Linear Time Example
# Must check every element once

def find_max(arr):
    """Find maximum element - must check all elements"""
    if not arr:
        return None
    
    max_val = arr[0]
    operations = 0
    
    for num in arr:
        operations += 1
        if num > max_val:
            max_val = num
    
    print(f"Found maximum: {max_val}")
    print(f"Operations: {operations}")
    return max_val

def linear_search(arr, target):
    """Search for element - worst case checks all"""
    operations = 0
    
    for i, num in enumerate(arr):
        operations += 1
        if num == target:
            print(f"✅ Found {target} at index {i}")
            print(f"Operations: {operations}")
            return i
    
    print(f"❌ {target} not found")
    print(f"Operations: {operations}")
    return -1

# Test
arr = [64, 34, 25, 12, 22, 11, 90, 88, 45, 50]

print("O(n) - Linear Time")
print("=" * 40)
print(f"Array: {arr}\n")

print("Finding maximum:")
find_max(arr)

print("\nSearching for 90:")
linear_search(arr, 90)

print(f"\n✅ Time complexity: O(n)")
print(f"Operations: {len(arr)} (checks every element)")
