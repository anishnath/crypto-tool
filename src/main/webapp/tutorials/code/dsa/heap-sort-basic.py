"""
Heap Sort - The Tournament Organizer
Build a max heap, then extract champions one by one!
"""

def heap_sort(arr):
    """
    Heap Sort: O(n log n) guaranteed, O(1) space
    1. Build max heap from array
    2. Extract max repeatedly, placing at end
    """
    n = len(arr)
    print(f"Original array: {arr}")
    print(f"\n{'='*60}")
    print("PHASE 1: Building Max Heap")
    print(f"{'='*60}")
    
    # Build max heap (rearrange array)
    build_max_heap(arr, n)
    
    print(f"\n{'='*60}")
    print("PHASE 2: Extracting Max and Sorting")
    print(f"{'='*60}\n")
    
    # Extract elements from heap one by one
    for i in range(n - 1, 0, -1):
        # Move current root (max) to end
        arr[0], arr[i] = arr[i], arr[0]
        print(f"Extracted max {arr[i]}, placed at index {i}")
        print(f"Array: {arr}")
        
        # Heapify the reduced heap
        heapify(arr, i, 0)
        print(f"After heapify: {arr}\n")
    
    return arr

def build_max_heap(arr, n):
    """
    Build max heap from unsorted array
    Start from last non-leaf node and heapify each
    Time: O(n) - surprisingly not O(n log n)!
    """
    # Index of last non-leaf node
    start_idx = n // 2 - 1
    
    print(f"Starting from last non-leaf node at index {start_idx}")
    
    # Perform reverse level order traversal
    for i in range(start_idx, -1, -1):
        print(f"\nHeapifying subtree rooted at index {i} (value: {arr[i]})")
        heapify(arr, n, i)
        print(f"After heapifying index {i}: {arr}")
    
    print(f"\n✓ Max heap built! Root (max): {arr[0]}")

def heapify(arr, n, i):
    """
    Heapify subtree rooted at index i
    Ensures max heap property: parent >= children
    Time: O(log n)
    """
    largest = i  # Initialize largest as root
    left = 2 * i + 1  # Left child
    right = 2 * i + 2  # Right child
    
    # Check if left child exists and is greater than root
    if left < n and arr[left] > arr[largest]:
        largest = left
    
    # Check if right child exists and is greater than largest so far
    if right < n and arr[right] > arr[largest]:
        largest = right
    
    # If largest is not root, swap and continue heapifying
    if largest != i:
        arr[i], arr[largest] = arr[largest], arr[i]
        print(f"  Swapped {arr[largest]} ↔ {arr[i]} (indices {largest} ↔ {i})")
        
        # Recursively heapify the affected subtree
        heapify(arr, n, largest)

def print_heap_as_tree(arr):
    """Visualize array as binary tree"""
    n = len(arr)
    if n == 0:
        return
    
    print("\nHeap as Tree:")
    level = 0
    i = 0
    while i < n:
        level_size = 2 ** level
        level_elements = arr[i:min(i + level_size, n)]
        
        # Print with indentation
        indent = " " * (4 * (3 - level)) if level < 3 else ""
        print(f"{indent}Level {level}: {level_elements}")
        
        i += level_size
        level += 1

# Example 1: Basic heap sort
print("=" * 60)
print("Example 1: Basic Heap Sort")
print("=" * 60)
arr1 = [12, 11, 13, 5, 6, 7]
print(f"Original: {arr1}")
print_heap_as_tree(arr1)

result1 = heap_sort(arr1.copy())
print(f"\n{'='*60}")
print(f"Final sorted array: {result1}")
print(f"{'='*60}\n")

# Example 2: Already sorted (still O(n log n))
print("\n" + "=" * 60)
print("Example 2: Already Sorted")
print("=" * 60)
arr2 = [1, 2, 3, 4, 5]
result2 = heap_sort(arr2.copy())
print(f"Sorted: {result2}\n")

# Example 3: Reverse sorted
print("=" * 60)
print("Example 3: Reverse Sorted")
print("=" * 60)
arr3 = [5, 4, 3, 2, 1]
result3 = heap_sort(arr3.copy())
print(f"Sorted: {result3}\n")

# Example 4: With duplicates
print("=" * 60)
print("Example 4: With Duplicates")
print("=" * 60)
arr4 = [4, 10, 3, 5, 1, 3, 10]
result4 = heap_sort(arr4.copy())
print(f"Sorted: {result4}\n")

print("=" * 60)
print("Key Insights:")
print("=" * 60)
print("✓ Build heap: O(n) - starts from bottom, most nodes sink little")
print("✓ Extract max: O(log n) × n times = O(n log n)")
print("✓ Total: O(n log n) guaranteed - no worst case!")
print("✓ Space: O(1) - in-place sorting")
print("✓ Not stable - equal elements may swap positions")
print("✓ Array representation: parent at i, children at 2i+1 and 2i+2")
