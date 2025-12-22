"""
Hash Maps & Sets
Practical implementations and interview patterns
Master Two Sum, Group Anagrams, and more!
"""

# ============================================================================
# HASH MAP IMPLEMENTATION
# ============================================================================

class HashMap:
    """
    HashMap - Key-Value pairs with O(1) operations
    Uses chaining for collision resolution
    """
    
    def __init__(self, size=16):
        self.size = size
        self.buckets = [[] for _ in range(size)]
        self.count = 0
    
    def _hash(self, key):
        """Hash function for any key type"""
        return hash(key) % self.size
    
    def put(self, key, value):
        """Insert or update key-value pair - O(1) average"""
        index = self._hash(key)
        
        # Update existing key
        for i, (k, v) in enumerate(self.buckets[index]):
            if k == key:
                self.buckets[index][i] = (key, value)
                print(f"➕ Updated {key} = {value}")
                return
        
        # Insert new key-value
        self.buckets[index].append((key, value))
        self.count += 1
        print(f"➕ Put {key} = {value}")
    
    def get(self, key):
        """Get value by key - O(1) average"""
        index = self._hash(key)
        
        for k, v in self.buckets[index]:
            if k == key:
                return v
        
        return None
    
    def remove(self, key):
        """Remove key - O(1) average"""
        index = self._hash(key)
        
        for i, (k, v) in enumerate(self.buckets[index]):
            if k == key:
                del self.buckets[index][i]
                self.count -= 1
                print(f"➖ Removed {key}")
                return True
        
        return False
    
    def contains_key(self, key):
        """Check if key exists - O(1) average"""
        return self.get(key) is not None
    
    def keys(self):
        """Get all keys"""
        result = []
        for bucket in self.buckets:
            for k, v in bucket:
                result.append(k)
        return result
    
    def values(self):
        """Get all values"""
        result = []
        for bucket in self.buckets:
            for k, v in bucket:
                result.append(v)
        return result
    
    def items(self):
        """Get all key-value pairs"""
        result = []
        for bucket in self.buckets:
            result.extend(bucket)
        return result

# ============================================================================
# HASH SET IMPLEMENTATION
# ============================================================================

class HashSet:
    """
    HashSet - Unique elements with O(1) operations
    No duplicates allowed
    """
    
    def __init__(self, size=16):
        self.size = size
        self.buckets = [[] for _ in range(size)]
        self.count = 0
    
    def _hash(self, value):
        """Hash function"""
        return hash(value) % self.size
    
    def add(self, value):
        """Add element - O(1) average"""
        if self.contains(value):
            print(f"✗ {value} already exists")
            return False
        
        index = self._hash(value)
        self.buckets[index].append(value)
        self.count += 1
        print(f"➕ Added {value}")
        return True
    
    def remove(self, value):
        """Remove element - O(1) average"""
        index = self._hash(value)
        
        if value in self.buckets[index]:
            self.buckets[index].remove(value)
            self.count -= 1
            print(f"➖ Removed {value}")
            return True
        
        return False
    
    def contains(self, value):
        """Check if element exists - O(1) average"""
        index = self._hash(value)
        return value in self.buckets[index]
    
    def to_list(self):
        """Convert to list"""
        result = []
        for bucket in self.buckets:
            result.extend(bucket)
        return result

# ============================================================================
# INTERVIEW PATTERN 1: Two Sum
# ============================================================================

def two_sum(nums, target):
    """
    Find two numbers that add up to target
    Time: O(n), Space: O(n)
    THE most asked interview question!
    """
    print(f"\n🔍 Two Sum: nums={nums}, target={target}")
    
    seen = {}  # HashMap: value -> index
    
    for i, num in enumerate(nums):
        complement = target - num
        
        if complement in seen:
            result = [seen[complement], i]
            print(f"  ✅ Found: {nums[seen[complement]]} + {num} = {target}")
            print(f"  Indices: {result}")
            return result
        
        seen[num] = i
        print(f"  Checking {num}, complement {complement} not found yet")
    
    print("  ✗ No solution found")
    return []

# ============================================================================
# INTERVIEW PATTERN 2: Group Anagrams
# ============================================================================

def group_anagrams(words):
    """
    Group words that are anagrams
    Time: O(n * k log k), Space: O(n * k)
    Very common interview question!
    """
    print(f"\n🔍 Group Anagrams: {words}")
    
    groups = {}  # HashMap: sorted_word -> [anagrams]
    
    for word in words:
        # Sort word to get key
        key = ''.join(sorted(word))
        
        if key not in groups:
            groups[key] = []
        
        groups[key].append(word)
        print(f"  '{word}' → key '{key}'")
    
    result = list(groups.values())
    print(f"  ✅ Groups: {result}")
    return result

# ============================================================================
# INTERVIEW PATTERN 3: First Non-Repeating Character
# ============================================================================

def first_non_repeating(s):
    """
    Find first character that appears only once
    Time: O(n), Space: O(1) - max 26 letters
    """
    print(f"\n🔍 First Non-Repeating: '{s}'")
    
    # Count frequencies
    freq = {}
    for char in s:
        freq[char] = freq.get(char, 0) + 1
    
    # Find first with count 1
    for char in s:
        if freq[char] == 1:
            print(f"  ✅ First non-repeating: '{char}'")
            return char
    
    print("  ✗ No non-repeating character")
    return None

# ============================================================================
# INTERVIEW PATTERN 4: Subarray Sum Equals K
# ============================================================================

def subarray_sum_k(nums, k):
    """
    Count subarrays with sum equal to k
    Time: O(n), Space: O(n)
    Uses prefix sum + HashMap!
    """
    print(f"\n🔍 Subarray Sum = {k}: {nums}")
    
    prefix_sum = 0
    sum_count = {0: 1}  # HashMap: prefix_sum -> count
    result = 0
    
    for num in nums:
        prefix_sum += num
        
        # Check if (prefix_sum - k) exists
        if prefix_sum - k in sum_count:
            result += sum_count[prefix_sum - k]
            print(f"  Found subarray ending at {num}, count: {sum_count[prefix_sum - k]}")
        
        # Update count
        sum_count[prefix_sum] = sum_count.get(prefix_sum, 0) + 1
    
    print(f"  ✅ Total subarrays: {result}")
    return result

# ============================================================================
# INTERVIEW PATTERN 5: Contains Duplicate
# ============================================================================

def contains_duplicate(nums):
    """
    Check if array has duplicates
    Time: O(n), Space: O(n)
    """
    print(f"\n🔍 Contains Duplicate: {nums}")
    
    seen = set()
    
    for num in nums:
        if num in seen:
            print(f"  ✅ Duplicate found: {num}")
            return True
        seen.add(num)
    
    print("  ✗ No duplicates")
    return False

# ============================================================================
# EXAMPLE 1: HashMap Operations
# ============================================================================

print("=" * 70)
print("Example 1: HashMap Operations")
print("=" * 70)

map = HashMap()

print("\nPutting key-value pairs:")
map.put("apple", 5)
map.put("banana", 3)
map.put("orange", 8)
map.put("apple", 10)  # Update

print("\nGetting values:")
print(f"apple: {map.get('apple')}")
print(f"banana: {map.get('banana')}")
print(f"kiwi: {map.get('kiwi')}")

print("\nAll keys:", map.keys())
print("All values:", map.values())

# ============================================================================
# EXAMPLE 2: HashSet Operations
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: HashSet Operations")
print("=" * 70)

set = HashSet()

print("\nAdding elements:")
set.add(1)
set.add(2)
set.add(3)
set.add(2)  # Duplicate

print("\nContains checks:")
print(f"Contains 2: {set.contains(2)}")
print(f"Contains 5: {set.contains(5)}")

print("\nSet elements:", set.to_list())

# ============================================================================
# EXAMPLE 3: Two Sum
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Two Sum (Most Asked!)")
print("=" * 70)

test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6),
]

for nums, target in test_cases:
    two_sum(nums, target)

# ============================================================================
# EXAMPLE 4: Group Anagrams
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Group Anagrams")
print("=" * 70)

words = ["eat", "tea", "tan", "ate", "nat", "bat"]
group_anagrams(words)

# ============================================================================
# EXAMPLE 5: First Non-Repeating Character
# ============================================================================

print("\n" + "=" * 70)
print("Example 5: First Non-Repeating Character")
print("=" * 70)

test_strings = ["leetcode", "loveleetcode", "aabb"]

for s in test_strings:
    first_non_repeating(s)

# ============================================================================
# EXAMPLE 6: Subarray Sum Equals K
# ============================================================================

print("\n" + "=" * 70)
print("Example 6: Subarray Sum Equals K")
print("=" * 70)

test_cases = [
    ([1, 1, 1], 2),
    ([1, 2, 3], 3),
]

for nums, k in test_cases:
    subarray_sum_k(nums, k)

# ============================================================================
# EXAMPLE 7: Contains Duplicate
# ============================================================================

print("\n" + "=" * 70)
print("Example 7: Contains Duplicate")
print("=" * 70)

test_arrays = [
    [1, 2, 3, 1],
    [1, 2, 3, 4],
]

for nums in test_arrays:
    contains_duplicate(nums)

# ============================================================================
# COMPLEXITY SUMMARY
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Summary")
print("=" * 70)

print(f"\n{'Operation':<30} {'HashMap':<20} {'HashSet':<20}")
print("─" * 70)
print(f"{'Put/Add':<30} {'O(1) average':<20} {'O(1) average':<20}")
print(f"{'Get/Contains':<30} {'O(1) average':<20} {'O(1) average':<20}")
print(f"{'Remove':<30} {'O(1) average':<20} {'O(1) average':<20}")
print(f"{'Space':<30} {'O(n)':<20} {'O(n)':<20}")

# ============================================================================
# INTERVIEW TIPS
# ============================================================================

print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)

print("\n✅ HashMap Patterns:")
print("  • Two Sum: Use HashMap to store complements")
print("  • Group Anagrams: Use sorted string as key")
print("  • Frequency counting: HashMap for counts")
print("  • Prefix sum: HashMap for cumulative sums")

print("\n✅ HashSet Patterns:")
print("  • Duplicate detection: Add to set, check contains")
print("  • Unique elements: Set automatically handles")
print("  • Fast lookup: O(1) membership testing")

print("\n✅ Common Mistakes:")
print("  • Forgetting to handle None/null keys")
print("  • Not considering collision resolution")
print("  • Assuming O(1) worst case (it's average!)")

print("\n✅ Interview Questions:")
print("  • Two Sum (most asked!)")
print("  • Group Anagrams")
print("  • First Non-Repeating Character")
print("  • Subarray Sum Equals K")
print("  • LRU Cache (HashMap + DLL)")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ HashMap: Key-value pairs, O(1) operations")
print("✓ HashSet: Unique elements, O(1) membership")
print("✓ Two Sum: THE most asked interview question")
print("✓ Use HashMap for frequency counting")
print("✓ Use HashSet for duplicate detection")
print("✓ Master these patterns for 80% of problems!")
