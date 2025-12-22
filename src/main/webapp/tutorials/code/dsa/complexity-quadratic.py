# O(n²) - Quadratic Time Example
# Bubble sort - nested loops over the array

def bubble_sort(arr):
    """Bubble sort with operation counting"""
    n = len(arr)
    operations = 0
    
    for i in range(n - 1):
        for j in range(n - i - 1):
            operations += 1
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
    
    print(f"Total operations: {operations}")
    return arr, operations

def has_duplicate(arr):
    """Check for duplicates - naive approach"""
    operations = 0
    
    for i in range(len(arr)):
        for j in range(i + 1, len(arr)):
            operations += 1
            if arr[i] == arr[j]:
                print(f"✅ Found duplicate: {arr[i]}")
                print(f"Operations: {operations}")
                return True
    
    print(f"❌ No duplicates found")
    print(f"Operations: {operations}")
    return False

# Test
arr = [64, 34, 25, 12, 22, 11, 90, 88]

print("O(n²) - Quadratic Time")
print("=" * 40)
print(f"Original array: {arr}")
print(f"Array size: {len(arr)}\n")

print("Bubble Sort:")
sorted_arr, ops = bubble_sort(arr.copy())
print(f"Sorted: {sorted_arr}\n")

print("Checking for duplicates:")
has_duplicate([1, 2, 3, 4, 5])

expected = len(arr) ** 2
print(f"\n✅ Time complexity: O(n²)")
print(f"For n={len(arr)}: ~{expected} operations")
print(f"For n=100: ~10,000 operations")
print(f"For n=1000: ~1,000,000 operations!")
