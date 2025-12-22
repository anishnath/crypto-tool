def linear_search(arr, target):
    """Check each element one by one"""
    for num in arr:
        if num == target:
            return True
    return False

# Test with a sample array
numbers = [5, 2, 8, 1, 9, 3, 7]
target = 7

if linear_search(numbers, target):
    print(f"Found {target} in the array!")
else:
    print(f"{target} not found in the array")

# Show how many operations it takes
print(f"\nFor {len(numbers)} elements, worst case: {len(numbers)} comparisons")
