# Merge Sort - Complexity Analysis
# Shows why it's O(n log n)

def merge_sort_with_stats(arr, depth=0):
    """Track operations to show O(n log n) complexity"""
    
    stats = {'comparisons': 0, 'merges': 0, 'depth': depth}
    
    def merge(left, right):
        """Merge with comparison counting"""
        result = []
        i = j = 0
        comparisons = 0
        
        while i < len(left) and j < len(right):
            comparisons += 1
            if left[i] <= right[j]:
                result.append(left[i])
                i += 1
            else:
                result.append(right[j])
                j += 1
        
        result.extend(left[i:])
        result.extend(right[j:])
        
        return result, comparisons
    
    if len(arr) <= 1:
        return arr, stats
    
    mid = len(arr) // 2
    left_half = arr[:mid]
    right_half = arr[mid:]
    
    # Recursively sort
    left_sorted, left_stats = merge_sort_with_stats(left_half, depth + 1)
    right_sorted, right_stats = merge_sort_with_stats(right_half, depth + 1)
    
    # Merge
    merged, merge_comps = merge(left_sorted, right_sorted)
    
    # Aggregate stats
    stats['comparisons'] = left_stats['comparisons'] + right_stats['comparisons'] + merge_comps
    stats['merges'] = left_stats['merges'] + right_stats['merges'] + 1
    stats['depth'] = max(left_stats['depth'], right_stats['depth'])
    
    return merged, stats

# Test with different sizes
print("=== Merge Sort Complexity Analysis ===\n")

for n in [8, 16, 32, 64]:
    arr = list(range(n, 0, -1))  # Worst case: reverse sorted
    result, stats = merge_sort_with_stats(arr)
    
    print(f"Array size: {n}")
    print(f"  Comparisons: {stats['comparisons']}")
    print(f"  Merge operations: {stats['merges']}")
    print(f"  Recursion depth: {stats['depth']}")
    print(f"  Expected (n log n): ~{n * stats['depth']}")
    print()

print("=== Key Observations ===")
print("1. Depth = log₂(n) - tree height")
print("2. Each level does O(n) work - merging")
print("3. Total: O(n) × O(log n) = O(n log n)")
print("\n✅ Guaranteed O(n log n) - no worst case!")
