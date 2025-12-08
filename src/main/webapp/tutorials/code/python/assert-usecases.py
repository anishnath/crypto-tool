# When to Use Assertions

print("=== When to Use Assert ===\n")

# 1. Check internal invariants
print("1. Internal invariants (things that MUST be true):")

def get_absolute(x):
    result = x if x >= 0 else -x
    # Internal invariant: result is always non-negative
    assert result >= 0, f"Bug! absolute value is negative: {result}"
    return result

print(f"   abs(-5) = {get_absolute(-5)}")
print(f"   abs(10) = {get_absolute(10)}")
print()

# 2. Check function preconditions (internal use)
print("2. Preconditions for internal functions:")

def _internal_sort(items, reverse=False):
    """Internal function - not exposed to users."""
    # These asserts document assumptions for developers
    assert isinstance(items, list), "items must be a list"
    assert all(isinstance(x, (int, float)) for x in items), "items must be numbers"

    return sorted(items, reverse=reverse)

result = _internal_sort([3, 1, 4, 1, 5])
print(f"   _internal_sort([3,1,4,1,5]) = {result}")
print()

# 3. Check postconditions (verify output)
print("3. Postconditions (verify your function works):")

def calculate_discount(price, percent):
    """Calculate discounted price."""
    assert 0 <= percent <= 100, f"Invalid percent: {percent}"

    discounted = price * (1 - percent / 100)

    # Postcondition: discount never increases price or goes negative
    assert 0 <= discounted <= price, \
        f"Bug! Discounted {discounted} invalid for price {price}"

    return discounted

print(f"   $100 with 20% off = ${calculate_discount(100, 20)}")
print()

# 4. Sanity checks in complex algorithms
print("4. Sanity checks in algorithms:")

def binary_search(sorted_list, target):
    """Find target in sorted list."""
    # Sanity check: list should be sorted
    assert sorted_list == sorted(sorted_list), "List must be sorted!"

    left, right = 0, len(sorted_list) - 1

    while left <= right:
        mid = (left + right) // 2

        # Invariant: target must be in [left, right] if it exists
        assert left <= mid <= right, f"Bug! mid={mid} outside [{left}, {right}]"

        if sorted_list[mid] == target:
            return mid
        elif sorted_list[mid] < target:
            left = mid + 1
        else:
            right = mid - 1

    return -1

nums = [1, 3, 5, 7, 9, 11]
print(f"   Find 7 in {nums}: index {binary_search(nums, 7)}")
print()

# 5. Type checking in development
print("5. Development-time type checking:")

def process_user_data(user_id, data):
    """Process user data - types checked in development."""
    assert isinstance(user_id, int), f"user_id must be int, got {type(user_id)}"
    assert isinstance(data, dict), f"data must be dict, got {type(data)}"
    assert 'name' in data, "data must have 'name' key"

    return f"Processed user {user_id}: {data['name']}"

result = process_user_data(123, {'name': 'Alice', 'age': 30})
print(f"   {result}")
print()

# 6. Document assumptions
print("6. Assert documents assumptions:")
print("""
# Assert makes assumptions explicit:

def calculate_tax(income):
    # Assumption: we only handle positive income
    assert income >= 0, "income must be non-negative"

    # Assumption: tax rate between 0% and 100%
    rate = get_tax_rate(income)
    assert 0 <= rate <= 1, f"Invalid tax rate: {rate}"

    return income * rate
""")

# 7. Summary
print("=== Use Assert For ===")
print("""
OK to use assert:
- Internal invariants (things that MUST be true)
- Development-time checks
- Documenting assumptions
- Catching programmer errors (bugs)
- Sanity checks in complex code

The key: assertions catch BUGS, not bad input!
""")
