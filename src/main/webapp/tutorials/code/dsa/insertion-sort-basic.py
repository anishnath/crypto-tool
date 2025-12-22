# Insertion Sort - Basic Implementation
# Like sorting playing cards in your hand

def insertion_sort(arr):
    """Insertion Sort - O(n²) worst case, O(n) best case"""
    n = len(arr)
    
    print(f"Sorting: {arr}\n")
    
    comparisons = 0
    swaps = 0
    
    # Start from second element (first is already "sorted")
    for i in range(1, n):
        key = arr[i]
        j = i - 1
        
        print(f"Pass {i}: Inserting {key} into sorted portion")
        
        # Move elements greater than key one position ahead
        while j >= 0 and arr[j] > key:
            comparisons += 1
            arr[j + 1] = arr[j]
            swaps += 1
            j -= 1
        
        # If we didn't move, still count the comparison
        if j >= 0:
            comparisons += 1
        
        # Place key in its correct position
        arr[j + 1] = key
        print(f"  After inserting: {arr}\n")
    
    print(f"Final sorted: {arr}")
    print(f"\nStats:")
    print(f"  Comparisons: {comparisons}")
    print(f"  Shifts: {swaps}")
    return arr

# Test
numbers = [64, 25, 12, 22, 11]
result = insertion_sort(numbers.copy())

print("\n=== Key Insight ===")
print("Insertion Sort is like sorting playing cards:")
print("- Pick a card")
print("- Insert it into the correct position in your sorted hand")
print("- Repeat for all cards")
print("\nBest for nearly sorted data!")
