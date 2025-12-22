"""
Advanced Hashing
Consistent Hashing, Bloom Filters, Rolling Hash
Advanced techniques for distributed systems and pattern matching!
"""

import hashlib
from collections import defaultdict

# ============================================================================
# CONSISTENT HASHING (Distributed Systems)
# ============================================================================

class ConsistentHash:
    """
    Consistent Hashing for distributed systems
    Minimizes key redistribution when nodes are added/removed
    Used in: Memcached, Cassandra, DynamoDB
    """
    
    def __init__(self, nodes=None, virtual_nodes=150):
        self.virtual_nodes = virtual_nodes
        self.ring = {}  # hash -> node
        self.sorted_keys = []
        self.nodes = set()
        
        if nodes:
            for node in nodes:
                self.add_node(node)
    
    def _hash(self, key):
        """Hash function using MD5"""
        return int(hashlib.md5(key.encode()).hexdigest(), 16)
    
    def add_node(self, node):
        """Add a node to the ring"""
        self.nodes.add(node)
        
        # Add virtual nodes for better distribution
        for i in range(self.virtual_nodes):
            virtual_key = f"{node}:{i}"
            hash_val = self._hash(virtual_key)
            self.ring[hash_val] = node
            self.sorted_keys.append(hash_val)
        
        self.sorted_keys.sort()
        print(f"➕ Added node '{node}' with {self.virtual_nodes} virtual nodes")
    
    def remove_node(self, node):
        """Remove a node from the ring"""
        if node not in self.nodes:
            return
        
        self.nodes.remove(node)
        
        # Remove all virtual nodes
        for i in range(self.virtual_nodes):
            virtual_key = f"{node}:{i}"
            hash_val = self._hash(virtual_key)
            if hash_val in self.ring:
                del self.ring[hash_val]
                self.sorted_keys.remove(hash_val)
        
        print(f"➖ Removed node '{node}'")
    
    def get_node(self, key):
        """Get the node responsible for a key"""
        if not self.ring:
            return None
        
        hash_val = self._hash(key)
        
        # Binary search for the first node >= hash_val
        idx = self._binary_search(hash_val)
        
        # Wrap around if needed
        if idx >= len(self.sorted_keys):
            idx = 0
        
        node = self.ring[self.sorted_keys[idx]]
        return node
    
    def _binary_search(self, hash_val):
        """Find first key >= hash_val"""
        left, right = 0, len(self.sorted_keys)
        
        while left < right:
            mid = (left + right) // 2
            if self.sorted_keys[mid] < hash_val:
                left = mid + 1
            else:
                right = mid
        
        return left
    
    def get_distribution(self, keys):
        """Show key distribution across nodes"""
        distribution = defaultdict(int)
        
        for key in keys:
            node = self.get_node(key)
            distribution[node] += 1
        
        return dict(distribution)

# ============================================================================
# BLOOM FILTER (Probabilistic Data Structure)
# ============================================================================

class BloomFilter:
    """
    Bloom Filter - Space-efficient probabilistic set
    Can have false positives, but NO false negatives
    Used in: Databases, CDNs, spell checkers
    """
    
    def __init__(self, size=1000, num_hashes=3):
        self.size = size
        self.num_hashes = num_hashes
        self.bit_array = [0] * size
        self.count = 0
    
    def _hash(self, item, seed):
        """Hash function with seed"""
        h = hashlib.md5(f"{item}{seed}".encode())
        return int(h.hexdigest(), 16) % self.size
    
    def add(self, item):
        """Add item to bloom filter"""
        for i in range(self.num_hashes):
            idx = self._hash(item, i)
            self.bit_array[idx] = 1
        
        self.count += 1
        print(f"➕ Added '{item}' to Bloom Filter")
    
    def contains(self, item):
        """Check if item might be in set (probabilistic)"""
        for i in range(self.num_hashes):
            idx = self._hash(item, i)
            if self.bit_array[idx] == 0:
                return False  # Definitely NOT in set
        
        return True  # MIGHT be in set (could be false positive)
    
    def false_positive_rate(self):
        """Estimate false positive rate"""
        # (1 - e^(-kn/m))^k
        # k = num_hashes, n = count, m = size
        import math
        k, n, m = self.num_hashes, self.count, self.size
        return (1 - math.exp(-k * n / m)) ** k

# ============================================================================
# ROLLING HASH (Rabin-Karp Algorithm)
# ============================================================================

class RollingHash:
    """
    Rolling Hash for efficient pattern matching
    Used in: Rabin-Karp string search, plagiarism detection
    Time: O(n + m) for pattern matching
    """
    
    def __init__(self, base=256, mod=10**9 + 7):
        self.base = base
        self.mod = mod
    
    def compute_hash(self, s):
        """Compute hash of string"""
        hash_val = 0
        for char in s:
            hash_val = (hash_val * self.base + ord(char)) % self.mod
        return hash_val
    
    def search(self, text, pattern):
        """
        Rabin-Karp pattern matching
        Returns all starting indices of pattern in text
        """
        print(f"\n🔍 Searching for '{pattern}' in '{text}'")
        
        n, m = len(text), len(pattern)
        if m > n:
            return []
        
        # Compute pattern hash
        pattern_hash = self.compute_hash(pattern)
        
        # Compute hash of first window
        text_hash = self.compute_hash(text[:m])
        
        # Precompute base^(m-1) for rolling
        h = pow(self.base, m - 1, self.mod)
        
        results = []
        
        # Check first window
        if text_hash == pattern_hash and text[:m] == pattern:
            results.append(0)
            print(f"  ✅ Found at index 0")
        
        # Roll the hash
        for i in range(1, n - m + 1):
            # Remove leading character
            text_hash = (text_hash - ord(text[i - 1]) * h) % self.mod
            
            # Add trailing character
            text_hash = (text_hash * self.base + ord(text[i + m - 1])) % self.mod
            
            # Check if hashes match
            if text_hash == pattern_hash:
                # Verify actual string (avoid hash collision)
                if text[i:i + m] == pattern:
                    results.append(i)
                    print(f"  ✅ Found at index {i}")
        
        if not results:
            print("  ✗ Pattern not found")
        
        return results

# ============================================================================
# EXAMPLE 1: Consistent Hashing
# ============================================================================

print("=" * 70)
print("Example 1: Consistent Hashing")
print("=" * 70)

ch = ConsistentHash(nodes=['server1', 'server2', 'server3'])

print("\nMapping keys to servers:")
keys = ['user1', 'user2', 'user3', 'user4', 'user5']

for key in keys:
    server = ch.get_node(key)
    print(f"  {key} → {server}")

print("\nKey distribution:")
distribution = ch.get_distribution(keys)
for server, count in sorted(distribution.items()):
    print(f"  {server}: {count} keys")

print("\n" + "─" * 70)
print("Adding new server (minimal redistribution):")
ch.add_node('server4')

print("\nNew key distribution:")
distribution = ch.get_distribution(keys)
for server, count in sorted(distribution.items()):
    print(f"  {server}: {count} keys")

# ============================================================================
# EXAMPLE 2: Bloom Filter
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Bloom Filter")
print("=" * 70)

bf = BloomFilter(size=100, num_hashes=3)

print("\nAdding words to Bloom Filter:")
words = ['apple', 'banana', 'orange', 'grape']
for word in words:
    bf.add(word)

print("\n" + "─" * 70)
print("Checking membership:")

test_words = ['apple', 'banana', 'kiwi', 'mango']
for word in test_words:
    result = bf.contains(word)
    if word in words:
        print(f"  '{word}': {result} ✅ (True Positive)")
    else:
        if result:
            print(f"  '{word}': {result} ⚠️  (False Positive!)")
        else:
            print(f"  '{word}': {result} ✅ (True Negative)")

print(f"\nEstimated false positive rate: {bf.false_positive_rate():.4f}")

# ============================================================================
# EXAMPLE 3: Rolling Hash (Rabin-Karp)
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Rolling Hash (Rabin-Karp)")
print("=" * 70)

rh = RollingHash()

test_cases = [
    ("AABAACAADAABAABA", "AABA"),
    ("hello world hello", "hello"),
    ("abcdefgh", "xyz"),
]

for text, pattern in test_cases:
    rh.search(text, pattern)

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Technique':<25} {'Operation':<20} {'Time':<20} {'Space':<15}")
print("─" * 80)
print(f"{'Consistent Hash':<25} {'Add/Remove Node':<20} {'O(K log K)':<20} {'O(K)':<15}")
print(f"{'Consistent Hash':<25} {'Get Node':<20} {'O(log K)':<20} {'O(K)':<15}")
print(f"{'Bloom Filter':<25} {'Add':<20} {'O(k)':<20} {'O(m)':<15}")
print(f"{'Bloom Filter':<25} {'Contains':<20} {'O(k)':<20} {'O(m)':<15}")
print(f"{'Rolling Hash':<25} {'Pattern Search':<20} {'O(n + m)':<20} {'O(1)':<15}")

print("\nWhere:")
print("  K = number of virtual nodes")
print("  k = number of hash functions")
print("  m = bloom filter size")
print("  n = text length, m = pattern length")

# ============================================================================
# INTERVIEW TIPS
# ============================================================================

print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)

print("\n✅ Consistent Hashing:")
print("  • Used in distributed caching (Memcached, Redis)")
print("  • Minimizes key redistribution when scaling")
print("  • Virtual nodes ensure even distribution")
print("  • Ask about: load balancing, CDN, distributed databases")

print("\n✅ Bloom Filters:")
print("  • Space-efficient probabilistic set membership")
print("  • Can have false positives, NO false negatives")
print("  • Used in: spell checkers, databases, CDNs")
print("  • Trade-off: space vs accuracy")

print("\n✅ Rolling Hash:")
print("  • Efficient pattern matching (Rabin-Karp)")
print("  • O(n + m) vs O(nm) brute force")
print("  • Used in: plagiarism detection, DNA matching")
print("  • Watch for hash collisions!")

print("\n✅ When to Use:")
print("  • Consistent Hash: Distributed systems, load balancing")
print("  • Bloom Filter: Quick membership test, save space")
print("  • Rolling Hash: Pattern matching, substring search")

# ============================================================================
# REAL-WORLD APPLICATIONS
# ============================================================================

print("\n" + "=" * 70)
print("Real-World Applications")
print("=" * 70)

print("\n🌐 Consistent Hashing:")
print("  • Amazon DynamoDB - data partitioning")
print("  • Memcached - distributed caching")
print("  • Cassandra - node assignment")
print("  • CDNs - server selection")

print("\n🔍 Bloom Filters:")
print("  • Google Chrome - malicious URL detection")
print("  • Medium - recommend articles you haven't read")
print("  • Bitcoin - transaction verification")
print("  • Databases - avoid disk lookups")

print("\n📝 Rolling Hash:")
print("  • Plagiarism detection systems")
print("  • DNA sequence matching")
print("  • File deduplication")
print("  • rsync - file synchronization")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Consistent Hashing: Distributed systems, minimal redistribution")
print("✓ Bloom Filters: Space-efficient, probabilistic membership")
print("✓ Rolling Hash: Efficient pattern matching O(n + m)")
print("✓ These are advanced techniques for system design!")
print("✓ Know when to use each in interviews!")
print("✓ Module 7: Hashing - COMPLETE! 🎉")
