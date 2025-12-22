def hash_search(arr, target):
    """Use hash table for instant lookup"""
    # Convert array to set (hash table)
    hash_set = set(arr)
    
    # Lookup is O(1) - constant time!
    if target in hash_set:
        print(f"Found {target} in the hash set!")
        return True
    else:
        print(f"{target} not found in the hash set")
        return False

# Test with an array
numbers = [5, 2, 8, 1, 9, 3, 7]
target = 7

hash_search(numbers, target)

# Show the power of hashing
print(f"\nFor {len(numbers)} elements, lookup time: O(1) - constant!")
print("No matter how large the array, lookup is always fast!")
