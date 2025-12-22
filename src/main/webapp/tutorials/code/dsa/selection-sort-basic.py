# Selection Sort - Basic Implementation
# Find minimum and swap - reduces number of swaps

def selection_sort(arr):
    """Selection Sort - O(n²) but fewer swaps than Bubble Sort"""
    n = len(arr)
    
    print(f"Sorting: {arr}\n")
    
    # Track swaps
    swaps = 0
    comparisons = 0
    
    for i in range(n - 1):
        # Find minimum in unsorted portion
        min_idx = i
        print(f"Pass {i + 1}: Finding minimum from index {i}...")
        
        for j in range(i + 1, n):
            comparisons += 1
            if arr[j] < arr[min_idx]:
                min_idx = j
        
        # Swap if needed
        if min_idx != i:
            arr[i], arr[min_idx] = arr[min_idx], arr[i]
            swaps += 1
            print(f"  Swapped {arr[min_idx]} and {arr[i]}: {arr}")
        else:
            print(f"  {arr[i]} already in correct position")
        
        print(f"  After pass {i + 1}: {arr}\n")
    
    print(f"Final sorted: {arr}")
    print(f"\nStats:")
    print(f"  Comparisons: {comparisons}")
    print(f"  Swaps: {swaps}")
    return arr

# Test
numbers = [64, 25, 12, 22, 11]
result = selection_sort(numbers.copy())

print("\n=== Key Insight ===")
print("Selection Sort makes fewer swaps than Bubble Sort!")
print("Bubble Sort: O(n²) swaps")
print("Selection Sort: O(n) swaps (at most n-1)")
