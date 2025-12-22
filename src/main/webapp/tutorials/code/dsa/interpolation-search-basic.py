"""
Interpolation Search - Smart Guessing for Uniform Data
Better than Binary Search for uniformly distributed data
Time: O(log log n) best case, O(n) worst case
"""

def interpolation_search(arr, target):
    """
    Interpolation Search - like looking up a phone book
    If searching for "Smith", you don't start at middle - you go near the end!
    """
    print(f"Searching for {target} in {arr}")
    print(f"Array size: {len(arr)}\n")
    
    left = 0
    right = len(arr) - 1
    steps = 0
    
    while left <= right and target >= arr[left] and target <= arr[right]:
        steps += 1
        
        # If only one element left
        if left == right:
            if arr[left] == target:
                print(f"Step {steps}: Only one element left at index {left}")
                print(f"✓ FOUND at index {left}")
                print(f"Total comparisons: {steps}")
                return left
            break
        
        # Calculate position using interpolation formula
        # pos = left + ((target - arr[left]) / (arr[right] - arr[left])) * (right - left)
        pos = left + int(((target - arr[left]) / (arr[right] - arr[left])) * (right - left))
        
        print(f"Step {steps}:")
        print(f"  Range: [{left}:{right}] = [{arr[left]}:{arr[right]}]")
        print(f"  Interpolated position: {pos}")
        print(f"  arr[{pos}] = {arr[pos]}")
        
        if arr[pos] == target:
            print(f"  ✓ FOUND at index {pos}!")
            print(f"\nTotal comparisons: {steps}")
            return pos
        
        if arr[pos] < target:
            print(f"  {arr[pos]} < {target}, search RIGHT")
            left = pos + 1
        else:
            print(f"  {arr[pos]} > {target}, search LEFT")
            right = pos - 1
    
    print(f"✗ NOT FOUND")
    print(f"Total comparisons: {steps}")
    return -1

def binary_search_comparison(arr, target):
    """Binary Search for comparison"""
    left, right = 0, len(arr) - 1
    steps = 0
    
    while left <= right:
        steps += 1
        mid = left + (right - left) // 2
        
        if arr[mid] == target:
            return steps
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    return steps

# Example 1: Uniform Distribution (Interpolation shines!)
print("=" * 70)
print("Example 1: Uniform Distribution - Interpolation Search Advantage")
print("=" * 70)
arr1 = list(range(0, 1000, 10))  # [0, 10, 20, 30, ..., 990]
target1 = 850

print(f"Searching for {target1} in uniformly distributed array [0, 10, 20, ..., 990]")
print(f"Array size: {len(arr1)}\n")

# Interpolation Search
print("INTERPOLATION SEARCH:")
print("-" * 70)
interp_result = interpolation_search(arr1, target1)

print("\n" + "=" * 70)
print("BINARY SEARCH (for comparison):")
print("-" * 70)
binary_steps = binary_search_comparison(arr1, target1)
print(f"Binary Search: {binary_steps} comparisons")
print(f"Interpolation Search: Much fewer steps!")

# Example 2: Small Array
print("\n" + "=" * 70)
print("Example 2: Small Uniform Array")
print("=" * 70)
arr2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
target2 = 7
result2 = interpolation_search(arr2, target2)

# Example 3: Target at Beginning
print("\n" + "=" * 70)
print("Example 3: Target Near Beginning")
print("=" * 70)
arr3 = list(range(0, 100, 5))  # [0, 5, 10, 15, ..., 95]
target3 = 10
result3 = interpolation_search(arr3, target3)

# Example 4: Target Not Found
print("\n" + "=" * 70)
print("Example 4: Target Not Found")
print("=" * 70)
arr4 = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
target4 = 35
result4 = interpolation_search(arr4, target4)

# Example 5: Non-Uniform Distribution (Interpolation struggles)
print("\n" + "=" * 70)
print("Example 5: Non-Uniform Distribution - Binary Search Better!")
print("=" * 70)
arr5 = [1, 2, 3, 4, 5, 100, 200, 300, 400, 500]  # Gap in middle
target5 = 400

print("INTERPOLATION SEARCH:")
print("-" * 70)
interp_result5 = interpolation_search(arr5, target5)

print("\n" + "=" * 70)
print("BINARY SEARCH:")
print("-" * 70)
binary_steps5 = binary_search_comparison(arr5, target5)
print(f"Binary Search: {binary_steps5} comparisons")
print("\nNote: For non-uniform data, Binary Search can be better!")

# Performance Comparison
print("\n" + "=" * 70)
print("Performance Analysis")
print("=" * 70)

print("\nInterpolation Search vs Binary Search:")
print(f"{'Array Size':<12} {'Uniform Data':<20} {'Non-Uniform Data':<20}")
print("-" * 60)
print(f"{'10':<12} {'Interp: ~1-2':<20} {'Binary: ~3-4':<20}")
print(f"{'100':<12} {'Interp: ~2-3':<20} {'Binary: ~6-7':<20}")
print(f"{'1,000':<12} {'Interp: ~3-4':<20} {'Binary: ~9-10':<20}")
print(f"{'10,000':<12} {'Interp: ~4-5':<20} {'Binary: ~13-14':<20}")
print(f"{'1,000,000':<12} {'Interp: ~5-6 ⭐':<20} {'Binary: ~19-20':<20}")

print("\n" + "=" * 70)
print("Key Insights:")
print("=" * 70)
print("✓ Interpolation Search: O(log log n) for uniform data")
print("✓ Binary Search: O(log n) always")
print("✓ Interpolation is FASTER for uniform distributions")
print("✓ Binary is SAFER for non-uniform data")
print("\n✓ Use Interpolation when:")
print("  - Data is uniformly distributed")
print("  - Large datasets (1M+ elements)")
print("  - Examples: phone books, dictionaries, sequential IDs")
print("\n✓ Use Binary when:")
print("  - Data distribution unknown")
print("  - Small to medium datasets")
print("  - Safety and predictability matter")
