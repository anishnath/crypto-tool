"""
Counting Sort - The Tally Counter
O(n) linear time sorting for small ranges!
"""

def counting_sort_basic(arr):
    """
    Basic Counting Sort (not stable)
    Time: O(n + k) where k = range
    Space: O(k)
    """
    if not arr:
        return arr
    
    print(f"Original array: {arr}")
    print(f"\n{'='*60}")
    print("PHASE 1: Counting Occurrences")
    print(f"{'='*60}")
    
    # Find range
    min_val = min(arr)
    max_val = max(arr)
    range_size = max_val - min_val + 1
    
    print(f"Min value: {min_val}")
    print(f"Max value: {max_val}")
    print(f"Range size: {range_size}")
    
    # Create count array
    count = [0] * range_size
    print(f"\nInitial count array (size {range_size}): {count}")
    
    # Count occurrences
    for num in arr:
        count[num - min_val] += 1
        print(f"Counted {num} → count[{num - min_val}] = {count[num - min_val]}")
    
    print(f"\nFinal count array: {count}")
    
    print(f"\n{'='*60}")
    print("PHASE 2: Reconstructing Sorted Array")
    print(f"{'='*60}\n")
    
    # Reconstruct sorted array
    result = []
    for i in range(range_size):
        value = i + min_val
        occurrences = count[i]
        if occurrences > 0:
            print(f"Value {value} appears {occurrences} time(s)")
            result.extend([value] * occurrences)
    
    return result

def counting_sort_stable(arr):
    """
    Stable Counting Sort (preserves order of equal elements)
    Time: O(n + k) where k = range
    Space: O(n + k)
    """
    if not arr:
        return arr
    
    print(f"Original array: {arr}")
    print(f"\n{'='*60}")
    print("STABLE VERSION - Uses Cumulative Counts")
    print(f"{'='*60}")
    
    # Find range
    min_val = min(arr)
    max_val = max(arr)
    range_size = max_val - min_val + 1
    
    print(f"Range: {min_val} to {max_val} (size: {range_size})")
    
    # Count occurrences
    count = [0] * range_size
    for num in arr:
        count[num - min_val] += 1
    
    print(f"\nCount array: {count}")
    
    # Convert to cumulative counts
    for i in range(1, range_size):
        count[i] += count[i - 1]
    
    print(f"Cumulative counts: {count}")
    print("(Each position shows: how many elements ≤ this value)")
    
    # Build output array (right to left for stability)
    output = [0] * len(arr)
    print(f"\n{'='*60}")
    print("Building output (right to left for stability):")
    print(f"{'='*60}\n")
    
    for i in range(len(arr) - 1, -1, -1):
        num = arr[i]
        index = count[num - min_val] - 1
        output[index] = num
        count[num - min_val] -= 1
        print(f"Place {num} at index {index} → output: {output}")
    
    return output

# Example 1: Basic counting sort
print("=" * 60)
print("Example 1: Basic Counting Sort (Ages)")
print("=" * 60)
ages = [23, 19, 27, 19, 25, 23, 30]
result1 = counting_sort_basic(ages.copy())
print(f"\nSorted: {result1}\n")

# Example 2: Stable counting sort
print("\n" + "=" * 60)
print("Example 2: Stable Counting Sort (Test Scores)")
print("=" * 60)
scores = [85, 90, 85, 78, 90, 95, 78]
result2 = counting_sort_stable(scores.copy())
print(f"\nSorted: {result2}\n")

# Example 3: With negative numbers
print("=" * 60)
print("Example 3: With Negative Numbers")
print("=" * 60)
temps = [-5, 0, -3, 2, -5, 3, 0]
result3 = counting_sort_basic(temps.copy())
print(f"\nSorted: {result3}\n")

# Example 4: Small range (perfect for counting sort!)
print("=" * 60)
print("Example 4: Grades (A=4, B=3, C=2, D=1, F=0)")
print("=" * 60)
grades = [3, 4, 2, 3, 4, 1, 2, 4, 3]
grade_names = ['F', 'D', 'C', 'B', 'A']
result4 = counting_sort_basic(grades.copy())
result4_names = [grade_names[g] for g in result4]
print(f"\nSorted grades: {result4_names}\n")

# Example 5: Large range (NOT ideal for counting sort!)
print("=" * 60)
print("Example 5: Large Range (Inefficient!)")
print("=" * 60)
large_range = [1, 1000000, 5, 999999]
print(f"Array: {large_range}")
print(f"Range: {min(large_range)} to {max(large_range)}")
print(f"Range size: {max(large_range) - min(large_range) + 1}")
print("⚠️ Would need 1,000,000 element count array!")
print("⚠️ Use comparison-based sort instead!\n")

print("=" * 60)
print("Key Insights:")
print("=" * 60)
print("✓ Time: O(n + k) where k = range")
print("✓ Space: O(k) for count array + O(n) for output")
print("✓ Linear time when k is small!")
print("✓ No comparisons - counts occurrences instead")
print("✓ Stable version preserves order of equal elements")
print("✓ Perfect for: ages, grades, small integers")
print("✓ Terrible for: large ranges, arbitrary numbers")
print("✓ Foundation for Radix Sort!")
