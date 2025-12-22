"""
Quick Sort - Basic Implementation
The Smart Organizer: Pick a pivot, partition, recurse!
"""

def quick_sort(arr):
    """
    Quick Sort: Divide and conquer with smart partitioning
    Time: O(n log n) average, O(n²) worst
    Space: O(log n) for recursion stack
    """
    print(f"Sorting: {arr}")
    quick_sort_helper(arr, 0, len(arr) - 1)
    return arr

def quick_sort_helper(arr, low, high):
    """Recursive helper function"""
    if low < high:
        # Partition the array and get pivot index
        pivot_index = partition(arr, low, high)
        
        print(f"Pivot {arr[pivot_index]} is in final position {pivot_index}")
        print(f"Array: {arr}")
        
        # Recursively sort left and right subarrays
        quick_sort_helper(arr, low, pivot_index - 1)
        quick_sort_helper(arr, pivot_index + 1, high)

def partition(arr, low, high):
    """
    Lomuto Partition Scheme
    - Choose last element as pivot
    - Partition array around pivot
    - Return pivot's final position
    """
    pivot = arr[high]  # Choose last element as pivot
    print(f"\n--- Partitioning [{low}:{high}] with pivot {pivot} ---")
    
    i = low - 1  # Index of smaller element
    
    for j in range(low, high):
        # If current element is smaller than pivot
        if arr[j] <= pivot:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]
            print(f"Swap: {arr[j]} ↔ {arr[i]} → {arr}")
    
    # Place pivot in correct position
    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    print(f"Pivot {pivot} placed at index {i + 1}")
    
    return i + 1

# Example 1: Basic sorting
print("=" * 50)
print("Example 1: Basic Quick Sort")
print("=" * 50)
arr1 = [38, 27, 43, 3, 9, 82, 10]
print(f"Original: {arr1}")
result1 = quick_sort(arr1.copy())
print(f"\nSorted: {result1}\n")

# Example 2: Already sorted (worst case!)
print("=" * 50)
print("Example 2: Already Sorted (Worst Case!)")
print("=" * 50)
arr2 = [1, 2, 3, 4, 5]
print(f"Original: {arr2}")
print("Notice: Each partition only reduces size by 1!")
result2 = quick_sort(arr2.copy())
print(f"\nSorted: {result2}\n")

# Example 3: Reverse sorted
print("=" * 50)
print("Example 3: Reverse Sorted")
print("=" * 50)
arr3 = [5, 4, 3, 2, 1]
print(f"Original: {arr3}")
result3 = quick_sort(arr3.copy())
print(f"\nSorted: {result3}\n")

# Example 4: Duplicates
print("=" * 50)
print("Example 4: With Duplicates")
print("=" * 50)
arr4 = [3, 7, 3, 1, 7, 3]
print(f"Original: {arr4}")
result4 = quick_sort(arr4.copy())
print(f"\nSorted: {result4}\n")

print("=" * 50)
print("Key Insights:")
print("=" * 50)
print("✓ Each partition puts ONE element in final position")
print("✓ Pivot choice matters! (last element can be bad)")
print("✓ Already sorted = worst case O(n²)")
print("✓ Random data = average case O(n log n)")
print("✓ In-place sorting (no extra array needed)")
