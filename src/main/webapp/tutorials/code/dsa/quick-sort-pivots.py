"""
Quick Sort - Different Pivot Strategies
Comparing: First, Last, Middle, Random, Median-of-Three
"""

import random
import time

def quick_sort_last_pivot(arr, low, high):
    """Strategy 1: Last element as pivot (Lomuto)"""
    if low < high:
        pivot_index = partition_last(arr, low, high)
        quick_sort_last_pivot(arr, low, pivot_index - 1)
        quick_sort_last_pivot(arr, pivot_index + 1, high)

def partition_last(arr, low, high):
    """Lomuto partition: last element as pivot"""
    pivot = arr[high]
    i = low - 1
    for j in range(low, high):
        if arr[j] <= pivot:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]
    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    return i + 1

def quick_sort_middle_pivot(arr, low, high):
    """Strategy 2: Middle element as pivot"""
    if low < high:
        pivot_index = partition_middle(arr, low, high)
        quick_sort_middle_pivot(arr, low, pivot_index - 1)
        quick_sort_middle_pivot(arr, pivot_index + 1, high)

def partition_middle(arr, low, high):
    """Middle element as pivot"""
    mid = (low + high) // 2
    # Move middle to end for standard partition
    arr[mid], arr[high] = arr[high], arr[mid]
    return partition_last(arr, low, high)

def quick_sort_random_pivot(arr, low, high):
    """Strategy 3: Random element as pivot"""
    if low < high:
        pivot_index = partition_random(arr, low, high)
        quick_sort_random_pivot(arr, low, pivot_index - 1)
        quick_sort_random_pivot(arr, pivot_index + 1, high)

def partition_random(arr, low, high):
    """Random element as pivot"""
    rand_index = random.randint(low, high)
    # Move random to end for standard partition
    arr[rand_index], arr[high] = arr[high], arr[rand_index]
    return partition_last(arr, low, high)

def quick_sort_median_of_three(arr, low, high):
    """Strategy 4: Median of first, middle, last"""
    if low < high:
        pivot_index = partition_median_of_three(arr, low, high)
        quick_sort_median_of_three(arr, low, pivot_index - 1)
        quick_sort_median_of_three(arr, pivot_index + 1, high)

def partition_median_of_three(arr, low, high):
    """Median of three as pivot"""
    mid = (low + high) // 2
    
    # Find median of arr[low], arr[mid], arr[high]
    if arr[low] > arr[mid]:
        arr[low], arr[mid] = arr[mid], arr[low]
    if arr[low] > arr[high]:
        arr[low], arr[high] = arr[high], arr[low]
    if arr[mid] > arr[high]:
        arr[mid], arr[high] = arr[high], arr[mid]
    
    # Now arr[mid] is the median, move it to end
    arr[mid], arr[high] = arr[high], arr[mid]
    return partition_last(arr, low, high)

# Test different strategies
def test_strategy(name, sort_func, arr):
    """Test a pivot strategy"""
    test_arr = arr.copy()
    start = time.perf_counter()
    sort_func(test_arr, 0, len(test_arr) - 1)
    end = time.perf_counter()
    return (end - start) * 1000  # Convert to ms

print("=" * 70)
print("Quick Sort Pivot Strategies Comparison")
print("=" * 70)

# Test Case 1: Random data (best for all strategies)
print("\n📊 Test 1: Random Data (n=1000)")
print("-" * 70)
random_data = [random.randint(1, 1000) for _ in range(1000)]

strategies = [
    ("Last Element", quick_sort_last_pivot),
    ("Middle Element", quick_sort_middle_pivot),
    ("Random Element", quick_sort_random_pivot),
    ("Median-of-Three", quick_sort_median_of_three)
]

for name, func in strategies:
    time_ms = test_strategy(name, func, random_data)
    print(f"{name:20} → {time_ms:6.2f}ms")

# Test Case 2: Already sorted (worst for last pivot!)
print("\n📊 Test 2: Already Sorted (n=500) - Worst Case for Last Pivot!")
print("-" * 70)
sorted_data = list(range(500))

for name, func in strategies:
    time_ms = test_strategy(name, func, sorted_data)
    print(f"{name:20} → {time_ms:6.2f}ms")

# Test Case 3: Reverse sorted
print("\n📊 Test 3: Reverse Sorted (n=500)")
print("-" * 70)
reverse_data = list(range(500, 0, -1))

for name, func in strategies:
    time_ms = test_strategy(name, func, reverse_data)
    print(f"{name:20} → {time_ms:6.2f}ms")

# Test Case 4: Many duplicates
print("\n📊 Test 4: Many Duplicates (n=1000)")
print("-" * 70)
duplicate_data = [random.randint(1, 10) for _ in range(1000)]

for name, func in strategies:
    time_ms = test_strategy(name, func, duplicate_data)
    print(f"{name:20} → {time_ms:6.2f}ms")

print("\n" + "=" * 70)
print("Key Insights:")
print("=" * 70)
print("✓ Last Pivot: Simple but TERRIBLE on sorted data (O(n²))")
print("✓ Middle Pivot: Better than last, still can be bad")
print("✓ Random Pivot: Good average case, prevents worst case")
print("✓ Median-of-Three: Best overall, used in practice")
print("\n💡 Real libraries use Median-of-Three or Random!")
print("💡 C++ std::sort uses Intro Sort (Quick + Heap)")
