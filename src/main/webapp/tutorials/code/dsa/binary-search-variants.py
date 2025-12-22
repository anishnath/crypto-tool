"""
Binary Search Variants - Interview Favorites
Common binary search problems that appear in FAANG interviews
All variants use the same O(log n) approach with modifications
"""

def binary_search_first_occurrence(arr, target):
    """
    Find FIRST occurrence of target in sorted array with duplicates
    Example: [1, 2, 2, 2, 3, 4] target=2 → index 1
    """
    print(f"Finding FIRST occurrence of {target} in {arr}\n")
    
    left, right = 0, len(arr) - 1
    result = -1
    steps = 0
    
    while left <= right:
        steps += 1
        mid = left + (right - left) // 2
        print(f"Step {steps}: left={left}, right={right}, mid={mid}, arr[mid]={arr[mid]}")
        
        if arr[mid] == target:
            result = mid  # Found, but keep searching LEFT
            right = mid - 1
            print(f"  Found at {mid}, searching left for first occurrence...")
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    if result != -1:
        print(f"\n✓ First occurrence at index {result}")
    else:
        print(f"\n✗ Not found")
    return result

def binary_search_last_occurrence(arr, target):
    """
    Find LAST occurrence of target in sorted array with duplicates
    Example: [1, 2, 2, 2, 3, 4] target=2 → index 3
    """
    print(f"Finding LAST occurrence of {target} in {arr}\n")
    
    left, right = 0, len(arr) - 1
    result = -1
    steps = 0
    
    while left <= right:
        steps += 1
        mid = left + (right - left) // 2
        print(f"Step {steps}: left={left}, right={right}, mid={mid}, arr[mid]={arr[mid]}")
        
        if arr[mid] == target:
            result = mid  # Found, but keep searching RIGHT
            left = mid + 1
            print(f"  Found at {mid}, searching right for last occurrence...")
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    if result != -1:
        print(f"\n✓ Last occurrence at index {result}")
    else:
        print(f"\n✗ Not found")
    return result

def count_occurrences(arr, target):
    """
    Count occurrences using first and last occurrence
    O(log n) - much better than O(n) linear count!
    """
    first = binary_search_first_occurrence(arr, target)
    if first == -1:
        return 0
    last = binary_search_last_occurrence(arr, target)
    return last - first + 1

def search_rotated_sorted_array(arr, target):
    """
    Search in rotated sorted array
    Example: [4, 5, 6, 7, 0, 1, 2] (rotated at index 4)
    Key: One half is always sorted!
    """
    print(f"Searching for {target} in rotated array {arr}\n")
    
    left, right = 0, len(arr) - 1
    steps = 0
    
    while left <= right:
        steps += 1
        mid = left + (right - left) // 2
        print(f"Step {steps}: left={left}, right={right}, mid={mid}")
        print(f"  arr[left]={arr[left]}, arr[mid]={arr[mid]}, arr[right]={arr[right]}")
        
        if arr[mid] == target:
            print(f"\n✓ Found at index {mid}")
            return mid
        
        # Determine which half is sorted
        if arr[left] <= arr[mid]:  # Left half is sorted
            print(f"  Left half [{left}:{mid}] is sorted")
            if arr[left] <= target < arr[mid]:
                print(f"  Target in sorted left half")
                right = mid - 1
            else:
                print(f"  Target in right half")
                left = mid + 1
        else:  # Right half is sorted
            print(f"  Right half [{mid}:{right}] is sorted")
            if arr[mid] < target <= arr[right]:
                print(f"  Target in sorted right half")
                left = mid + 1
            else:
                print(f"  Target in left half")
                right = mid - 1
    
    print(f"\n✗ Not found")
    return -1

def find_peak_element(arr):
    """
    Find peak element (greater than neighbors)
    Example: [1, 3, 20, 4, 1, 0] → peak at index 2 (value 20)
    """
    print(f"Finding peak element in {arr}\n")
    
    left, right = 0, len(arr) - 1
    steps = 0
    
    while left < right:
        steps += 1
        mid = left + (right - left) // 2
        print(f"Step {steps}: left={left}, right={right}, mid={mid}")
        print(f"  arr[mid]={arr[mid]}, arr[mid+1]={arr[mid + 1]}")
        
        if arr[mid] < arr[mid + 1]:
            print(f"  Ascending, peak is to the RIGHT")
            left = mid + 1
        else:
            print(f"  Descending, peak is at mid or LEFT")
            right = mid
    
    print(f"\n✓ Peak element {arr[left]} at index {left}")
    return left

def search_insert_position(arr, target):
    """
    Find position where target should be inserted to maintain sorted order
    Example: [1, 3, 5, 6] target=2 → index 1
    """
    print(f"Finding insert position for {target} in {arr}\n")
    
    left, right = 0, len(arr) - 1
    
    while left <= right:
        mid = left + (right - left) // 2
        print(f"Checking mid={mid}, arr[mid]={arr[mid]}")
        
        if arr[mid] == target:
            print(f"✓ Target exists at index {mid}")
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    
    print(f"✓ Insert position: index {left}")
    return left

def find_sqrt(n):
    """
    Find integer square root using binary search
    Example: sqrt(8) = 2 (since 2² = 4 ≤ 8 < 3² = 9)
    """
    print(f"Finding sqrt({n}) using binary search\n")
    
    if n < 2:
        return n
    
    left, right = 1, n // 2
    result = 0
    
    while left <= right:
        mid = left + (right - left) // 2
        square = mid * mid
        print(f"Trying mid={mid}, {mid}² = {square}")
        
        if square == n:
            print(f"✓ Perfect square! sqrt({n}) = {mid}")
            return mid
        elif square < n:
            result = mid  # Store potential answer
            left = mid + 1
            print(f"  Too small, try larger")
        else:
            right = mid - 1
            print(f"  Too large, try smaller")
    
    print(f"✓ Integer sqrt({n}) = {result}")
    return result

# Example 1: First and Last Occurrence
print("=" * 70)
print("Example 1: First and Last Occurrence")
print("=" * 70)
arr1 = [1, 2, 2, 2, 2, 3, 4, 5]
target1 = 2
first = binary_search_first_occurrence(arr1, target1)
print()
last = binary_search_last_occurrence(arr1, target1)
print(f"\nOccurrences of {target1}: indices [{first}:{last+1}] = {arr1[first:last+1]}")
print(f"Count: {last - first + 1}")

# Example 2: Rotated Sorted Array
print("\n" + "=" * 70)
print("Example 2: Search in Rotated Sorted Array")
print("=" * 70)
arr2 = [4, 5, 6, 7, 0, 1, 2]
target2 = 0
result2 = search_rotated_sorted_array(arr2, target2)

# Example 3: Peak Element
print("\n" + "=" * 70)
print("Example 3: Find Peak Element")
print("=" * 70)
arr3 = [1, 3, 20, 4, 1, 0]
peak = find_peak_element(arr3)

# Example 4: Insert Position
print("\n" + "=" * 70)
print("Example 4: Search Insert Position")
print("=" * 70)
arr4 = [1, 3, 5, 6]
target4 = 2
pos = search_insert_position(arr4, target4)

# Example 5: Square Root
print("\n" + "=" * 70)
print("Example 5: Integer Square Root")
print("=" * 70)
for n in [8, 16, 25, 100]:
    sqrt = find_sqrt(n)
    print()

# Summary
print("\n" + "=" * 70)
print("Binary Search Variants Summary")
print("=" * 70)
print("\n1. First/Last Occurrence:")
print("   - Modify condition to keep searching left/right")
print("   - Use: Count occurrences in O(log n)")
print("\n2. Rotated Sorted Array:")
print("   - Key insight: One half is always sorted")
print("   - Check which half is sorted, then decide direction")
print("\n3. Peak Element:")
print("   - Compare mid with mid+1")
print("   - If ascending, peak is right; if descending, peak is left/mid")
print("\n4. Insert Position:")
print("   - Standard binary search")
print("   - Return left pointer when not found")
print("\n5. Square Root:")
print("   - Binary search on answer space [1, n/2]")
print("   - Check if mid² ≤ n")
print("\n✓ All variants: O(log n) time complexity!")
print("✓ Master these for FAANG interviews!")
