# Insertion Sort - Best Case Demo
# Shows why it's O(n) on sorted data

def insertion_sort_with_stats(arr, name="Array"):
    """Track operations to show best vs worst case"""
    n = len(arr)
    comparisons = 0
    shifts = 0
    
    for i in range(1, n):
        key = arr[i]
        j = i - 1
        
        while j >= 0 and arr[j] > key:
            comparisons += 1
            arr[j + 1] = arr[j]
            shifts += 1
            j -= 1
        
        if j >= 0:
            comparisons += 1
        
        arr[j + 1] = key
    
    return arr, comparisons, shifts

# Test on different inputs
print("=== Insertion Sort: Best vs Worst Case ===\n")

# Best case: Already sorted
sorted_arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
result, comps, shifts = insertion_sort_with_stats(sorted_arr.copy(), "Sorted")
print(f"Already Sorted: {sorted_arr}")
print(f"  Comparisons: {comps}")
print(f"  Shifts: {shifts}")
print(f"  Time: O(n) - Just {comps} comparisons!\n")

# Worst case: Reverse sorted
reverse_arr = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
result, comps, shifts = insertion_sort_with_stats(reverse_arr.copy(), "Reverse")
print(f"Reverse Sorted: {reverse_arr}")
print(f"  Comparisons: {comps}")
print(f"  Shifts: {shifts}")
print(f"  Time: O(n²) - {comps} comparisons!\n")

# Nearly sorted
nearly_sorted = [1, 2, 3, 4, 5, 6, 7, 10, 8, 9]
result, comps, shifts = insertion_sort_with_stats(nearly_sorted.copy(), "Nearly Sorted")
print(f"Nearly Sorted: {nearly_sorted}")
print(f"  Comparisons: {comps}")
print(f"  Shifts: {shifts}")
print(f"  Time: ~O(n) - Very efficient!\n")

print("=== Key Takeaway ===")
print("Insertion Sort is ADAPTIVE:")
print("- Sorted data: O(n) ✅")
print("- Random data: O(n²) ❌")
print("- Nearly sorted: ~O(n) ✅")
print("\nPerfect for data that's almost sorted!")
