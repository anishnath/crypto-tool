"""
Exponential Search - For Unbounded/Infinite Arrays
Combines doubling + binary search
Time: O(log n), Space: O(1)
"""

def binary_search_range(arr, target, left, right):
    """Helper: Binary search in a specific range"""
    steps = 0
    while left <= right:
        steps += 1
        mid = left + (right - left) // 2
        print(f"    Binary search step {steps}: arr[{mid}] = {arr[mid]}")
        
        if arr[mid] == target:
            return mid, steps
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    return -1, steps

def exponential_search(arr, target):
    """
    Exponential Search - for unbounded or very large arrays
    Strategy: Find range by doubling, then binary search
    """
    print(f"Searching for {target} in array of size {len(arr)}")
    print(f"First few elements: {arr[:min(10, len(arr))]}")
    print()
    
    n = len(arr)
    
    # If target is at first position
    if arr[0] == target:
        print("Step 1: Found at index 0!")
        return 0
    
    # Find range by doubling
    print("Phase 1: Find range by doubling")
    print("-" * 70)
    i = 1
    step = 0
    while i < n and arr[i] <= target:
        step += 1
        print(f"Step {step}: Check arr[{i}] = {arr[i]}")
        if arr[i] == target:
            print(f"  ✓ FOUND at index {i}!")
            return i
        print(f"  {arr[i]} <= {target}, double index: {i} → {min(i * 2, n - 1)}")
        i = i * 2
    
    # Found range: [i//2, min(i, n-1)]
    left = i // 2
    right = min(i, n - 1)
    
    print(f"\nRange found: [{left}:{right}]")
    print(f"Range values: [{arr[left]}:{arr[right]}]")
    print()
    
    # Binary search in found range
    print("Phase 2: Binary search in range")
    print("-" * 70)
    result, binary_steps = binary_search_range(arr, target, left, right)
    
    if result != -1:
        print(f"\n✓ FOUND at index {result}")
        print(f"Total steps: {step} (doubling) + {binary_steps} (binary) = {step + binary_steps}")
    else:
        print(f"\n✗ NOT FOUND")
        print(f"Total steps: {step + binary_steps}")
    
    return result

def exponential_search_unbounded(get_element, target):
    """
    Exponential Search for unbounded array
    get_element(i) returns element at index i, or None if out of bounds
    """
    print(f"Searching for {target} in UNBOUNDED array")
    print()
    
    # Check first element
    if get_element(0) == target:
        print("Found at index 0!")
        return 0
    
    # Find range by doubling
    print("Finding range by doubling...")
    i = 1
    while True:
        val = get_element(i)
        if val is None:  # Reached end
            break
        print(f"Check index {i}: value = {val}")
        if val == target:
            print(f"✓ FOUND at index {i}!")
            return i
        if val > target:
            break
        i = i * 2
    
    # Binary search in range [i//2, i]
    print(f"\nBinary search in range [{i//2}:{i}]")
    left = i // 2
    right = i
    
    while left <= right:
        mid = left + (right - left) // 2
        val = get_element(mid)
        
        if val is None or val > target:
            right = mid - 1
        elif val == target:
            print(f"✓ FOUND at index {mid}!")
            return mid
        else:
            left = mid + 1
    
    print("✗ NOT FOUND")
    return -1

# Example 1: Basic Exponential Search
print("=" * 70)
print("Example 1: Basic Exponential Search")
print("=" * 70)
arr1 = [1, 2, 3, 4, 5, 10, 15, 20, 25, 30, 40, 50, 60, 70, 80, 90, 100]
target1 = 60
result1 = exponential_search(arr1, target1)

# Example 2: Target Near Beginning
print("\n" + "=" * 70)
print("Example 2: Target Near Beginning (Exponential Advantage!)")
print("=" * 70)
arr2 = list(range(1, 1001))  # [1, 2, 3, ..., 1000]
target2 = 8
result2 = exponential_search(arr2, target2)
print(f"\nNote: Found in just a few steps instead of log₂(1000) ≈ 10 steps!")

# Example 3: Target at End
print("\n" + "=" * 70)
print("Example 3: Target Near End")
print("=" * 70)
arr3 = list(range(0, 100, 2))  # [0, 2, 4, 6, ..., 98]
target3 = 96
result3 = exponential_search(arr3, target3)

# Example 4: Target Not Found
print("\n" + "=" * 70)
print("Example 4: Target Not Found")
print("=" * 70)
arr4 = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
target4 = 10
result4 = exponential_search(arr4, target4)

# Example 5: Unbounded Array Simulation
print("\n" + "=" * 70)
print("Example 5: Unbounded Array (Infinite Stream)")
print("=" * 70)

# Simulate unbounded array
infinite_arr = list(range(1, 10001))  # Pretend this is infinite

def get_element(i):
    """Simulate getting element from unbounded array"""
    if i < len(infinite_arr):
        return infinite_arr[i]
    return None

target5 = 5000
result5 = exponential_search_unbounded(get_element, target5)

# Comparison with Binary Search
print("\n" + "=" * 70)
print("Exponential Search vs Binary Search")
print("=" * 70)

print("\nWhen to use Exponential Search:")
print("✓ Unbounded/infinite arrays (streams, files)")
print("✓ Target likely near beginning")
print("✓ Don't know array size")
print("✓ Examples: log files, infinite streams")

print("\nWhen to use Binary Search:")
print("✓ Known array size")
print("✓ Target position unknown")
print("✓ Standard sorted array")

print("\n" + "=" * 70)
print("Performance Comparison")
print("=" * 70)

print(f"\n{'Scenario':<30} {'Exponential':<20} {'Binary':<20}")
print("-" * 70)
print(f"{'Target at index 8 (n=1000)':<30} {'~3 steps ⭐':<20} {'~10 steps':<20}")
print(f"{'Target at index 500 (n=1000)':<30} {'~12 steps':<20} {'~10 steps ⭐':<20}")
print(f"{'Unbounded array':<30} {'Works! ⭐':<20} {'Needs size':<20}")

print("\n" + "=" * 70)
print("Key Insights:")
print("=" * 70)
print("✓ Exponential Search: O(log n) time")
print("✓ Best for: Unbounded arrays, target near start")
print("✓ Combines: Doubling (find range) + Binary Search")
print("✓ Space: O(1) - no extra space needed")
print("\n✓ Real-world uses:")
print("  - Searching in log files")
print("  - Infinite data streams")
print("  - When array size unknown")
print("  - Debugging: find first occurrence of error")
