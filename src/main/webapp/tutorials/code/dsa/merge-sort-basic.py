# Merge Sort - Divide and Conquer
# Break the problem into smaller pieces, solve them, then merge

def merge_sort(arr):
    """Merge Sort - O(n log n) guaranteed!"""
    
    def merge(left, right):
        """Merge two sorted arrays into one"""
        result = []
        i = j = 0
        
        # Compare elements from both arrays
        while i < len(left) and j < len(right):
            if left[i] <= right[j]:
                result.append(left[i])
                i += 1
            else:
                result.append(right[j])
                j += 1
        
        # Add remaining elements
        result.extend(left[i:])
        result.extend(right[j:])
        
        return result
    
    # Base case: array of 1 element is already sorted
    if len(arr) <= 1:
        return arr
    
    # Divide: split array in half
    mid = len(arr) // 2
    left_half = arr[:mid]
    right_half = arr[mid:]
    
    print(f"Splitting: {arr} → {left_half} | {right_half}")
    
    # Conquer: recursively sort both halves
    left_sorted = merge_sort(left_half)
    right_sorted = merge_sort(right_half)
    
    # Combine: merge the sorted halves
    merged = merge(left_sorted, right_sorted)
    print(f"Merging: {left_sorted} + {right_sorted} → {merged}")
    
    return merged

# Test
numbers = [38, 27, 43, 3, 9, 82, 10]
print("Original:", numbers)
print("\n=== Sorting Process ===\n")
result = merge_sort(numbers.copy())
print(f"\nFinal sorted: {result}")

print("\n=== Key Insight ===")
print("Merge Sort uses Divide and Conquer:")
print("1. Divide: Split array in half")
print("2. Conquer: Sort each half recursively")
print("3. Combine: Merge sorted halves")
print("\nAlways O(n log n) - guaranteed performance!")
