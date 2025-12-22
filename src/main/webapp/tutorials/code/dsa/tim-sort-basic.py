"""
Tim Sort - The Hybrid Champion
Python's default sorting algorithm!
Combines Insertion Sort + Merge Sort with adaptive optimizations
Best: O(n), Average/Worst: O(n log n), Stable
"""

def tim_sort(arr):
    """
    Simplified Tim Sort implementation
    Real Tim Sort has ~700 lines with many optimizations
    This version shows the core concepts
    """
    if not arr or len(arr) <= 1:
        return arr
    
    print(f"Original array: {arr}")
    print(f"\n{'='*70}")
    print("TIM SORT - The Hybrid Champion (Python's default!)")
    print(f"{'='*70}\n")
    
    n = len(arr)
    minrun = calculate_minrun(n)
    
    print(f"Array size: {n}")
    print(f"Minimum run length (minrun): {minrun}")
    print(f"\n{'='*70}")
    print("PHASE 1: Create Runs (find sorted sequences)")
    print(f"{'='*70}\n")
    
    # Phase 1: Create runs using Insertion Sort
    runs = []
    i = 0
    
    while i < n:
        # Find natural run (already sorted sequence)
        run_start = i
        run_end = i + 1
        
        if run_end < n:
            # Check if ascending or descending
            if arr[run_end] >= arr[i]:
                # Ascending run
                while run_end < n and arr[run_end] >= arr[run_end - 1]:
                    run_end += 1
            else:
                # Descending run - reverse it
                while run_end < n and arr[run_end] < arr[run_end - 1]:
                    run_end += 1
                # Reverse to make ascending
                arr[run_start:run_end] = arr[run_start:run_end][::-1]
                print(f"Found descending run at [{run_start}:{run_end}], reversed it")
        
        run_length = run_end - run_start
        
        # Extend run to minrun using Insertion Sort
        if run_length < minrun:
            extend_to = min(run_start + minrun, n)
            print(f"\nRun [{run_start}:{run_end}] length {run_length} < minrun {minrun}")
            print(f"Extending to position {extend_to} using Insertion Sort...")
            
            insertion_sort(arr, run_start, extend_to)
            run_end = extend_to
            run_length = run_end - run_start
        
        run = arr[run_start:run_end]
        runs.append((run_start, run_end))
        
        print(f"✓ Run {len(runs)}: [{run_start}:{run_end}] = {run} (length {run_length})")
        
        i = run_end
    
    print(f"\n{'='*70}")
    print(f"PHASE 2: Merge Runs (combine sorted sequences)")
    print(f"{'='*70}\n")
    print(f"Total runs created: {len(runs)}\n")
    
    # Phase 2: Merge runs
    while len(runs) > 1:
        # Simplified merging - just merge adjacent runs
        # Real Tim Sort uses a stack and complex merge rules
        
        print(f"Current runs: {len(runs)}")
        
        # Merge first two runs
        run1_start, run1_end = runs[0]
        run2_start, run2_end = runs[1]
        
        print(f"Merging run [{run1_start}:{run1_end}] + [{run2_start}:{run2_end}]")
        print(f"  Run 1: {arr[run1_start:run1_end]}")
        print(f"  Run 2: {arr[run2_start:run2_end]}")
        
        # Merge the two runs
        merge(arr, run1_start, run1_end, run2_end)
        
        print(f"  Result: {arr[run1_start:run2_end]}\n")
        
        # Update runs list
        runs[0] = (run1_start, run2_end)
        runs.pop(1)
    
    print(f"{'='*70}")
    print(f"TIM SORT COMPLETE!")
    print(f"{'='*70}\n")
    
    return arr

def calculate_minrun(n):
    """
    Calculate minimum run length
    Real Tim Sort uses complex logic, we use simplified version
    Typically returns value between 32 and 64
    """
    r = 0
    while n >= 64:
        r |= n & 1
        n >>= 1
    return n + r

def insertion_sort(arr, left, right):
    """
    Insertion Sort for small runs
    Efficient for small arrays and nearly sorted data
    """
    for i in range(left + 1, right):
        key = arr[i]
        j = i - 1
        while j >= left and arr[j] > key:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = key

def merge(arr, left, mid, right):
    """
    Merge two sorted runs
    Uses temporary array (like Merge Sort)
    Real Tim Sort uses galloping mode for optimization
    """
    # Create temp arrays
    left_part = arr[left:mid]
    right_part = arr[mid:right]
    
    i = j = 0
    k = left
    
    # Merge
    while i < len(left_part) and j < len(right_part):
        if left_part[i] <= right_part[j]:
            arr[k] = left_part[i]
            i += 1
        else:
            arr[k] = right_part[j]
            j += 1
        k += 1
    
    # Copy remaining
    while i < len(left_part):
        arr[k] = left_part[i]
        i += 1
        k += 1
    
    while j < len(right_part):
        arr[k] = right_part[j]
        j += 1
        k += 1

# Example 1: Random array
print("=" * 70)
print("Example 1: Random Array")
print("=" * 70)
arr1 = [5, 2, 8, 1, 9, 3, 7, 4, 6]
result1 = tim_sort(arr1.copy())
print(f"Final sorted: {result1}\n")

# Example 2: Partially sorted
print("\n" + "=" * 70)
print("Example 2: Partially Sorted (Tim Sort's strength!)")
print("=" * 70)
arr2 = [1, 2, 3, 4, 5, 9, 8, 7, 6]  # First half sorted, second half reverse
result2 = tim_sort(arr2.copy())
print(f"Final sorted: {result2}\n")

# Example 3: Already sorted (best case!)
print("\n" + "=" * 70)
print("Example 3: Already Sorted (Best Case - O(n)!)")
print("=" * 70)
arr3 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
result3 = tim_sort(arr3.copy())
print(f"Final sorted: {result3}\n")

# Example 4: Reverse sorted
print("\n" + "=" * 70)
print("Example 4: Reverse Sorted")
print("=" * 70)
arr4 = [9, 8, 7, 6, 5, 4, 3, 2, 1]
result4 = tim_sort(arr4.copy())
print(f"Final sorted: {result4}\n")

# Example 5: With duplicates
print("\n" + "=" * 70)
print("Example 5: With Duplicates (Stable Sort!)")
print("=" * 70)
arr5 = [3, 1, 4, 1, 5, 9, 2, 6, 5]
result5 = tim_sort(arr5.copy())
print(f"Final sorted: {result5}\n")

# Demonstrate Python's built-in sort (uses Tim Sort!)
print("=" * 70)
print("Python's Built-in Sort (Uses Tim Sort!)")
print("=" * 70)
arr6 = [5, 2, 8, 1, 9, 3, 7, 4, 6]
print(f"Original: {arr6}")
arr6.sort()  # This uses Tim Sort!
print(f"After .sort(): {arr6}")
print("\nEvery time you use .sort() or sorted() in Python, you're using Tim Sort!")

print("\n" + "=" * 70)
print("Key Insights:")
print("=" * 70)
print("✓ Best case: O(n) - when data is already sorted!")
print("✓ Average/Worst: O(n log n) - guaranteed like Merge Sort")
print("✓ Stable: Preserves order of equal elements")
print("✓ Adaptive: Exploits existing order in data")
print("✓ Hybrid: Uses Insertion Sort for small runs, Merge Sort for large")
print("✓ Real-world: Optimized for partially sorted data")
print("✓ Production: Powers Python, Java, Android, Swift, and more!")
print("✓ Proven: 20+ years in production, billions of sorts daily")
print("\nTim Sort is why Python's .sort() is so fast!")
