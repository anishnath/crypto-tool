# Space Complexity: O(n) - Extra Space
# Creates new data structures proportional to input size

def reverse_array_copy(arr):
    """Reverse array by creating new array - O(n) space"""
    reversed_arr = []
    
    for i in range(len(arr) - 1, -1, -1):
        reversed_arr.append(arr[i])
    
    return reversed_arr

def filter_even_numbers(arr):
    """Create new array with even numbers - O(n) space"""
    even_numbers = []
    
    for num in arr:
        if num % 2 == 0:
            even_numbers.append(num)
    
    return even_numbers

def create_frequency_map(arr):
    """Create hash map of frequencies - O(n) space"""
    frequency = {}
    
    for num in arr:
        frequency[num] = frequency.get(num, 0) + 1
    
    return frequency

# Test
arr = [64, 34, 25, 12, 22, 11, 90, 88, 34, 22]

print("Space Complexity: O(n) - Extra Space")
print("=" * 40)
print(f"Original array: {arr}")
print(f"Array size: {len(arr)}\n")

# Reverse with copy
reversed_arr = reverse_array_copy(arr)
print(f"Reversed (new array): {reversed_arr}")
print(f"Extra space: {len(reversed_arr)} elements\n")

# Filter evens
even_nums = filter_even_numbers(arr)
print(f"Even numbers: {even_nums}")
print(f"Extra space: {len(even_nums)} elements\n")

# Frequency map
freq_map = create_frequency_map(arr)
print(f"Frequency map: {freq_map}")
print(f"Extra space: {len(freq_map)} entries\n")

print("✅ Space complexity: O(n)")
print("Creates new data structures")
print("Space usage grows with input size")
print(f"For n={len(arr)}: uses ~{len(arr)} extra space")
