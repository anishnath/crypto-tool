# Bubble Sort - Optimized with Early Exit
# Stop if array becomes sorted before all passes

def bubble_sort_optimized(arr):
    """Optimized Bubble Sort with early exit"""
    n = len(arr)
    
    print(f"Sorting: {arr}\n")
    
    for i in range(n - 1):
        swapped = False  # Flag to detect if any swap happened
        print(f"Pass {i + 1}:")
        
        for j in range(n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                swapped = True
                print(f"  Swapped: {arr}")
        
        if not swapped:
            print(f"  No swaps - array is sorted!")
            break
        
        print(f"  After pass {i + 1}: {arr}\n")
    
    return arr

# Test with nearly sorted array
print("=== Test 1: Nearly Sorted ===")
arr1 = [1, 2, 4, 3, 5]
result1 = bubble_sort_optimized(arr1.copy())
print(f"Final: {result1}\n")

# Test with already sorted
print("=== Test 2: Already Sorted ===")
arr2 = [1, 2, 3, 4, 5]
result2 = bubble_sort_optimized(arr2.copy())
print(f"Final: {result2}\n")

print("=== Optimization Impact ===")
print("Best case: O(n) - already sorted, exits after 1 pass")
print("Average/Worst: O(n²) - still needs all passes")
print("✅ Great for nearly sorted data!")
