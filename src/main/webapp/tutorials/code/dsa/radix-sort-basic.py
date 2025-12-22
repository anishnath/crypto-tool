"""
Radix Sort - The Card Sorter
Sort digit-by-digit using stable Counting Sort!
O(d × n) linear time for fixed-length keys
"""

def radix_sort(arr):
    """
    LSD (Least Significant Digit) Radix Sort
    Time: O(d × n) where d = number of digits
    Space: O(n + k) where k = 10 (base)
    """
    if not arr or len(arr) <= 1:
        return arr
    
    print(f"Original array: {arr}")
    print(f"\n{'='*70}")
    print("LSD RADIX SORT - Sorting digit-by-digit (right to left)")
    print(f"{'='*70}")
    
    # Find maximum number to know number of digits
    max_num = max(arr)
    num_digits = len(str(max_num))
    
    print(f"Maximum number: {max_num}")
    print(f"Number of digits: {num_digits}")
    print(f"Number of passes needed: {num_digits}\n")
    
    # Do counting sort for every digit
    exp = 1  # 10^0 = 1 (ones), 10^1 = 10 (tens), etc.
    
    for digit_pos in range(num_digits):
        print(f"{'='*70}")
        print(f"PASS {digit_pos + 1}: Sorting by {get_digit_name(digit_pos)} digit")
        print(f"{'='*70}")
        
        # Show current digits
        print(f"\nCurrent state: {arr}")
        print(f"Digits at position {digit_pos}:")
        for num in arr:
            digit = (num // exp) % 10
            print(f"  {num:3d} → digit = {digit}")
        
        # Perform counting sort on this digit
        arr = counting_sort_by_digit(arr, exp)
        
        print(f"\nAfter sorting by {get_digit_name(digit_pos)} digit: {arr}\n")
        
        exp *= 10
    
    return arr

def counting_sort_by_digit(arr, exp):
    """
    Stable counting sort for a specific digit position
    exp: 1 for ones, 10 for tens, 100 for hundreds, etc.
    """
    n = len(arr)
    output = [0] * n
    count = [0] * 10  # Digits 0-9
    
    # Count occurrences of each digit
    for num in arr:
        digit = (num // exp) % 10
        count[digit] += 1
    
    print(f"\nCount array (how many of each digit): {count}")
    
    # Convert to cumulative counts (for stable sort)
    for i in range(1, 10):
        count[i] += count[i - 1]
    
    print(f"Cumulative counts: {count}")
    
    # Build output array (right to left for stability)
    for i in range(n - 1, -1, -1):
        num = arr[i]
        digit = (num // exp) % 10
        output[count[digit] - 1] = num
        count[digit] -= 1
    
    return output

def get_digit_name(pos):
    """Get human-readable digit position name"""
    names = ["ones", "tens", "hundreds", "thousands", "ten-thousands"]
    return names[pos] if pos < len(names) else f"10^{pos}"

# Example 1: Basic Radix Sort
print("=" * 70)
print("Example 1: Basic Radix Sort")
print("=" * 70)
arr1 = [170, 45, 75, 90, 802, 24, 2, 66]
result1 = radix_sort(arr1.copy())
print(f"{'='*70}")
print(f"FINAL SORTED ARRAY: {result1}")
print(f"{'='*70}\n")

# Example 2: With duplicates
print("\n" + "=" * 70)
print("Example 2: With Duplicates")
print("=" * 70)
arr2 = [329, 457, 657, 839, 436, 720, 355, 457]
result2 = radix_sort(arr2.copy())
print(f"Final sorted: {result2}\n")

# Example 3: Already sorted
print("=" * 70)
print("Example 3: Already Sorted")
print("=" * 70)
arr3 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
result3 = radix_sort(arr3.copy())
print(f"Final sorted: {result3}\n")

# Example 4: Reverse sorted
print("=" * 70)
print("Example 4: Reverse Sorted")
print("=" * 70)
arr4 = [987, 654, 321, 210, 100]
result4 = radix_sort(arr4.copy())
print(f"Final sorted: {result4}\n")

# Example 5: Single digit numbers
print("=" * 70)
print("Example 5: Single Digit Numbers")
print("=" * 70)
arr5 = [9, 3, 7, 1, 5, 2, 8, 4, 6]
result5 = radix_sort(arr5.copy())
print(f"Final sorted: {result5}\n")

# Demonstrate why stability matters
print("=" * 70)
print("Example 6: Why Stability Matters")
print("=" * 70)
print("Sorting [12, 22, 32, 42] (all have same ones digit)")
print("\nWithout stability:")
print("  After ones sort: Could be [42, 32, 22, 12] (reversed!)")
print("  After tens sort: [12, 22, 32, 42] (correct by luck)")
print("\nWith stability (what we use):")
print("  After ones sort: [12, 22, 32, 42] (preserves order)")
print("  After tens sort: [12, 22, 32, 42] (correct!)")
print("\nStability ensures previous sorting is preserved!\n")

print("=" * 70)
print("Key Insights:")
print("=" * 70)
print("✓ Time: O(d × n) where d = number of digits")
print("✓ Space: O(n + k) where k = 10 (base)")
print("✓ Linear time for fixed-length keys!")
print("✓ Each pass uses stable Counting Sort")
print("✓ LSD: Simple, always d passes")
print("✓ Stability is CRUCIAL - preserves previous sorting")
print("✓ Perfect for: phone numbers, IDs, fixed-length integers")
print("✓ Extends Counting Sort to larger ranges!")
