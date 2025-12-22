# Analyzing Recursive Algorithms
# Example: Merge Sort - Divide and Conquer

def merge_sort(arr):
    """
    Merge Sort: T(n) = 2T(n/2) + O(n)
    - Divides array into 2 halves: 2T(n/2)
    - Merges them back: O(n)
    """
    if len(arr) <= 1:
        return arr
    
    # Divide
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])   # T(n/2)
    right = merge_sort(arr[mid:])  # T(n/2)
    
    # Conquer (merge)
    return merge(left, right)      # O(n)

def merge(left, right):
    """Merge two sorted arrays - O(n) time"""
    result = []
    i = j = 0
    
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    
    result.extend(left[i:])
    result.extend(right[j:])
    return result

# Test
arr = [64, 34, 25, 12, 22, 11, 90]
print("Original:", arr)
sorted_arr = merge_sort(arr)
print("Sorted:", sorted_arr)

print("\n📊 Recurrence Relation:")
print("T(n) = 2T(n/2) + O(n)")
print("\nUsing Master Theorem:")
print("a = 2 (two subproblems)")
print("b = 2 (each is n/2)")
print("f(n) = O(n) (merge work)")
print("\nResult: T(n) = O(n log n)")
