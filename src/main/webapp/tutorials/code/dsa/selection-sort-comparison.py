# Selection Sort vs Bubble Sort
# Compare the two algorithms

def bubble_sort(arr):
    """Bubble Sort for comparison"""
    arr = arr.copy()
    n = len(arr)
    swaps = 0
    comparisons = 0
    
    for i in range(n - 1):
        for j in range(n - i - 1):
            comparisons += 1
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                swaps += 1
    
    return arr, swaps, comparisons

def selection_sort(arr):
    """Selection Sort for comparison"""
    arr = arr.copy()
    n = len(arr)
    swaps = 0
    comparisons = 0
    
    for i in range(n - 1):
        min_idx = i
        for j in range(i + 1, n):
            comparisons += 1
            if arr[j] < arr[min_idx]:
                min_idx = j
        
        if min_idx != i:
            arr[i], arr[min_idx] = arr[min_idx], arr[i]
            swaps += 1
    
    return arr, swaps, comparisons

# Test with same array
test_array = [64, 25, 12, 22, 11, 90, 88, 45, 50, 33]

print("=== Comparison: Bubble Sort vs Selection Sort ===\n")
print(f"Array: {test_array}\n")

# Bubble Sort
result1, swaps1, comps1 = bubble_sort(test_array)
print("Bubble Sort:")
print(f"  Sorted: {result1}")
print(f"  Swaps: {swaps1}")
print(f"  Comparisons: {comps1}\n")

# Selection Sort
result2, swaps2, comps2 = selection_sort(test_array)
print("Selection Sort:")
print(f"  Sorted: {result2}")
print(f"  Swaps: {swaps2}")
print(f"  Comparisons: {comps2}\n")

print("=== Analysis ===")
print(f"Swap reduction: {swaps1 - swaps2} fewer swaps!")
print(f"Comparisons: Same O(n²) for both")
print("\n✅ Selection Sort wins when swaps are expensive!")
print("❌ Both are still O(n²) - use for small arrays only")
