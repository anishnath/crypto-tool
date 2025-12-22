# Bubble Sort - Basic Implementation
# Compare neighbors and swap if out of order

def bubble_sort(arr):
    """Basic Bubble Sort - O(n²)"""
    n = len(arr)
    
    print(f"Sorting: {arr}\n")
    
    # Outer loop: n-1 passes
    for i in range(n - 1):
        print(f"Pass {i + 1}:")
        
        # Inner loop: compare adjacent elements
        for j in range(n - i - 1):
            if arr[j] > arr[j + 1]:
                # Swap if out of order
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                print(f"  Swapped {arr[j+1]} and {arr[j]}: {arr}")
        
        print(f"  After pass {i + 1}: {arr}\n")
    
    return arr

# Test
numbers = [64, 34, 25, 12, 22]
result = bubble_sort(numbers.copy())
print(f"Final sorted: {result}")

print("\n=== Complexity Analysis ===")
print("Time: O(n²) - two nested loops")
print("Space: O(1) - sorts in place")
print("Passes: n-1 maximum")
print("Comparisons: n(n-1)/2")
