"""
Hash Tables - Fundamentals
Hash functions, collision resolution, load factor
Essential for O(1) average case operations!
"""

# ============================================================================
# HASH FUNCTIONS
# ============================================================================

def hash_division(key, table_size):
    """
    Division method: h(k) = k mod m
    Simple and fast, but table_size should be prime
    """
    return key % table_size

def hash_multiplication(key, table_size):
    """
    Multiplication method: h(k) = floor(m * (kA mod 1))
    A is constant (0 < A < 1), often A = (√5 - 1)/2
    """
    A = 0.6180339887  # (√5 - 1)/2 - golden ratio
    return int(table_size * ((key * A) % 1))

def hash_string(s, table_size):
    """
    String hashing using polynomial rolling hash
    h(s) = (s[0] * p^(n-1) + s[1] * p^(n-2) + ... + s[n-1]) mod m
    """
    p = 31  # Prime number for string hashing
    hash_value = 0
    for char in s:
        hash_value = (hash_value * p + ord(char)) % table_size
    return hash_value

# ============================================================================
# HASH TABLE WITH CHAINING
# ============================================================================

class HashTableChaining:
    """
    Hash table using chaining for collision resolution
    Time: O(1) average for insert/search/delete
    Space: O(n)
    """
    
    def __init__(self, size=10):
        self.size = size
        self.table = [[] for _ in range(size)]
        self.count = 0
    
    def _hash(self, key):
        """Hash function"""
        if isinstance(key, str):
            return hash_string(key, self.size)
        return hash_division(key, self.size)
    
    def insert(self, key, value):
        """Insert key-value pair - O(1) average"""
        index = self._hash(key)
        
        # Update if key exists
        for i, (k, v) in enumerate(self.table[index]):
            if k == key:
                self.table[index][i] = (key, value)
                print(f"➕ Updated {key} = {value} at index {index}")
                return
        
        # Insert new key-value
        self.table[index].append((key, value))
        self.count += 1
        print(f"➕ Inserted {key} = {value} at index {index} (chain length: {len(self.table[index])})")
        
        # Check load factor
        if self.load_factor() > 0.75:
            print(f"⚠️  Load factor {self.load_factor():.2f} > 0.75, consider rehashing!")
    
    def search(self, key):
        """Search for key - O(1) average"""
        index = self._hash(key)
        
        for k, v in self.table[index]:
            if k == key:
                print(f"🔍 Found {key} = {v} at index {index}")
                return v
        
        print(f"✗ Key {key} not found")
        return None
    
    def delete(self, key):
        """Delete key - O(1) average"""
        index = self._hash(key)
        
        for i, (k, v) in enumerate(self.table[index]):
            if k == key:
                del self.table[index][i]
                self.count -= 1
                print(f"➖ Deleted {key} from index {index}")
                return True
        
        print(f"✗ Key {key} not found")
        return False
    
    def load_factor(self):
        """Calculate load factor α = n/m"""
        return self.count / self.size
    
    def display(self):
        """Display hash table"""
        print(f"\nHash Table (Chaining) - Size: {self.size}, Count: {self.count}, Load Factor: {self.load_factor():.2f}")
        for i, chain in enumerate(self.table):
            if chain:
                print(f"  [{i}]: {chain}")

# ============================================================================
# HASH TABLE WITH OPEN ADDRESSING (Linear Probing)
# ============================================================================

class HashTableOpenAddressing:
    """
    Hash table using linear probing for collision resolution
    Time: O(1) average for insert/search/delete
    Space: O(m) where m is table size
    """
    
    def __init__(self, size=10):
        self.size = size
        self.table = [None] * size
        self.count = 0
        self.DELETED = object()  # Marker for deleted slots
    
    def _hash(self, key):
        """Hash function"""
        if isinstance(key, str):
            return hash_string(key, self.size)
        return hash_division(key, self.size)
    
    def _probe(self, key, i):
        """Linear probing: h(k, i) = (h(k) + i) mod m"""
        return (self._hash(key) + i) % self.size
    
    def insert(self, key, value):
        """Insert key-value pair - O(1) average"""
        if self.load_factor() >= 0.75:
            print(f"⚠️  Table is {self.load_factor():.0%} full, insertion may be slow!")
        
        for i in range(self.size):
            index = self._probe(key, i)
            
            # Empty slot or deleted slot
            if self.table[index] is None or self.table[index] is self.DELETED:
                self.table[index] = (key, value)
                self.count += 1
                print(f"➕ Inserted {key} = {value} at index {index} (probes: {i + 1})")
                return True
            
            # Update existing key
            if self.table[index][0] == key:
                self.table[index] = (key, value)
                print(f"➕ Updated {key} = {value} at index {index}")
                return True
        
        print(f"✗ Table is full, cannot insert {key}")
        return False
    
    def search(self, key):
        """Search for key - O(1) average"""
        for i in range(self.size):
            index = self._probe(key, i)
            
            if self.table[index] is None:
                print(f"✗ Key {key} not found")
                return None
            
            if self.table[index] is not self.DELETED and self.table[index][0] == key:
                print(f"🔍 Found {key} = {self.table[index][1]} at index {index} (probes: {i + 1})")
                return self.table[index][1]
        
        print(f"✗ Key {key} not found")
        return None
    
    def delete(self, key):
        """Delete key - O(1) average"""
        for i in range(self.size):
            index = self._probe(key, i)
            
            if self.table[index] is None:
                print(f"✗ Key {key} not found")
                return False
            
            if self.table[index] is not self.DELETED and self.table[index][0] == key:
                self.table[index] = self.DELETED
                self.count -= 1
                print(f"➖ Deleted {key} from index {index}")
                return True
        
        print(f"✗ Key {key} not found")
        return False
    
    def load_factor(self):
        """Calculate load factor α = n/m"""
        return self.count / self.size
    
    def display(self):
        """Display hash table"""
        print(f"\nHash Table (Open Addressing) - Size: {self.size}, Count: {self.count}, Load Factor: {self.load_factor():.2f}")
        for i, entry in enumerate(self.table):
            if entry is None:
                print(f"  [{i}]: Empty")
            elif entry is self.DELETED:
                print(f"  [{i}]: DELETED")
            else:
                print(f"  [{i}]: {entry}")

# ============================================================================
# EXAMPLE 1: Hash Table with Chaining
# ============================================================================

print("=" * 70)
print("Example 1: Hash Table with Chaining")
print("=" * 70)

ht_chain = HashTableChaining(size=7)

print("\nInserting key-value pairs:")
ht_chain.insert("apple", 5)
ht_chain.insert("banana", 3)
ht_chain.insert("orange", 8)
ht_chain.insert("grape", 2)
ht_chain.insert("mango", 6)

ht_chain.display()

print("\n" + "─" * 70)
print("Searching for keys:")
ht_chain.search("banana")
ht_chain.search("grape")
ht_chain.search("kiwi")

print("\n" + "─" * 70)
print("Deleting keys:")
ht_chain.delete("orange")
ht_chain.delete("kiwi")

ht_chain.display()

# ============================================================================
# EXAMPLE 2: Hash Table with Open Addressing
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Hash Table with Open Addressing (Linear Probing)")
print("=" * 70)

ht_open = HashTableOpenAddressing(size=7)

print("\nInserting key-value pairs:")
ht_open.insert("apple", 5)
ht_open.insert("banana", 3)
ht_open.insert("orange", 8)
ht_open.insert("grape", 2)
ht_open.insert("mango", 6)

ht_open.display()

print("\n" + "─" * 70)
print("Searching for keys:")
ht_open.search("banana")
ht_open.search("mango")
ht_open.search("kiwi")

print("\n" + "─" * 70)
print("Deleting keys:")
ht_open.delete("orange")
ht_open.delete("kiwi")

ht_open.display()

# ============================================================================
# EXAMPLE 3: Collision Demonstration
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Collision Demonstration")
print("=" * 70)

print("\nDemonstrating collisions with small table size:")
ht_small = HashTableChaining(size=3)

# These will likely collide
keys = ["cat", "dog", "bird", "fish", "lion"]
for i, key in enumerate(keys):
    ht_small.insert(key, i + 1)

ht_small.display()

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Operation':<20} {'Chaining':<20} {'Open Addressing':<20}")
print("─" * 70)
print(f"{'Insert':<20} {'O(1) average':<20} {'O(1) average':<20}")
print(f"{'Search':<20} {'O(1) average':<20} {'O(1) average':<20}")
print(f"{'Delete':<20} {'O(1) average':<20} {'O(1) average':<20}")
print(f"{'Space':<20} {'O(n)':<20} {'O(m)':<20}")
print(f"{'Worst Case':<20} {'O(n)':<20} {'O(n)':<20}")

print("\nLoad Factor (α = n/m):")
print("  • α < 0.75: Good performance")
print("  • α > 0.75: Consider rehashing")
print("  • Chaining: Can exceed 1.0")
print("  • Open Addressing: Must be < 1.0")

# ============================================================================
# INTERVIEW TIPS
# ============================================================================

print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)

print("\n✅ Hash Functions:")
print("  • Division method: Simple, use prime table size")
print("  • Multiplication method: Better distribution")
print("  • String hashing: Polynomial rolling hash")

print("\n✅ Collision Resolution:")
print("  • Chaining: Simple, handles high load factors")
print("  • Open Addressing: Better cache performance")
print("  • Linear probing: Simple but clustering")
print("  • Quadratic probing: Reduces clustering")

print("\n✅ Load Factor:")
print("  • Keep α < 0.75 for good performance")
print("  • Rehash when threshold exceeded")
print("  • Double table size (use next prime)")

print("\n✅ Common Interview Questions:")
print("  • Implement hash table from scratch")
print("  • Handle collisions efficiently")
print("  • Explain time complexity")
print("  • When to use chaining vs open addressing")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Hash tables provide O(1) average case operations")
print("✓ Good hash function distributes keys uniformly")
print("✓ Collisions are inevitable - handle them well")
print("✓ Chaining: simple, handles high load factors")
print("✓ Open addressing: better cache, requires α < 1")
print("✓ Monitor load factor, rehash when needed")
print("✓ Essential for many interview problems!")
