"""
Queue Variations - Circular Queue, Deque, Priority Queue
Advanced queue types for specific use cases
Essential for sliding window, scheduling, and more!
"""

from collections import deque as builtin_deque

# ============================================================================
# VARIATION 1: Circular Queue (Detailed)
# ============================================================================

class CircularQueue:
    """
    Circular Queue - Fixed size, wraps around
    Used in: Buffering, Round-robin scheduling
    """
    
    def __init__(self, capacity):
        self.items = [None] * capacity
        self.capacity = capacity
        self.front = 0
        self.rear = -1
        self.size = 0
    
    def enqueue(self, item):
        """Add to rear - O(1)"""
        if self.is_full():
            print(f"✗ Queue full! Cannot enqueue {item}")
            return False
        
        self.rear = (self.rear + 1) % self.capacity
        self.items[self.rear] = item
        self.size += 1
        print(f"➕ Enqueued {item} at index {self.rear}")
        return True
    
    def dequeue(self):
        """Remove from front - O(1)"""
        if self.is_empty():
            print("✗ Queue empty!")
            return None
        
        item = self.items[self.front]
        self.items[self.front] = None
        self.front = (self.front + 1) % self.capacity
        self.size -= 1
        print(f"➖ Dequeued {item}")
        return item
    
    def is_full(self):
        return self.size == self.capacity
    
    def is_empty(self):
        return self.size == 0
    
    def display(self):
        if self.is_empty():
            print("Queue: (empty)")
            return
        
        print(f"\nCircular Queue (capacity {self.capacity}):")
        print(f"  Array: {self.items}")
        print(f"  Front: {self.front}, Rear: {self.rear}, Size: {self.size}")

# ============================================================================
# VARIATION 2: Deque (Double-Ended Queue)
# ============================================================================

class Deque:
    """
    Deque - Add/remove from both ends
    Used in: Sliding window, palindrome check
    """
    
    def __init__(self):
        self.items = []
    
    def add_front(self, item):
        """Add to front - O(n) with list, O(1) with deque"""
        self.items.insert(0, item)
        print(f"➕ Added {item} to FRONT")
    
    def add_rear(self, item):
        """Add to rear - O(1)"""
        self.items.append(item)
        print(f"➕ Added {item} to REAR")
    
    def remove_front(self):
        """Remove from front - O(n) with list, O(1) with deque"""
        if self.is_empty():
            print("✗ Deque empty!")
            return None
        item = self.items.pop(0)
        print(f"➖ Removed {item} from FRONT")
        return item
    
    def remove_rear(self):
        """Remove from rear - O(1)"""
        if self.is_empty():
            print("✗ Deque empty!")
            return None
        item = self.items.pop()
        print(f"➖ Removed {item} from REAR")
        return item
    
    def peek_front(self):
        return self.items[0] if self.items else None
    
    def peek_rear(self):
        return self.items[-1] if self.items else None
    
    def is_empty(self):
        return len(self.items) == 0
    
    def display(self):
        if self.is_empty():
            print("Deque: (empty)")
        else:
            print(f"Deque: FRONT → {self.items} → REAR")

# ============================================================================
# VARIATION 3: Priority Queue (Simple)
# ============================================================================

class PriorityQueue:
    """
    Priority Queue - Highest priority dequeued first
    Used in: Dijkstra's, A*, task scheduling
    """
    
    def __init__(self):
        self.items = []  # List of (priority, value) tuples
    
    def enqueue(self, item, priority):
        """Add with priority - O(n) for insertion"""
        self.items.append((priority, item))
        self.items.sort(reverse=True)  # Higher priority first
        print(f"➕ Enqueued {item} with priority {priority}")
    
    def dequeue(self):
        """Remove highest priority - O(1)"""
        if self.is_empty():
            print("✗ Queue empty!")
            return None
        
        priority, item = self.items.pop(0)
        print(f"➖ Dequeued {item} (priority {priority})")
        return item
    
    def peek(self):
        if self.is_empty():
            return None
        return self.items[0][1]
    
    def is_empty(self):
        return len(self.items) == 0
    
    def display(self):
        if self.is_empty():
            print("Priority Queue: (empty)")
        else:
            print("\nPriority Queue (highest priority first):")
            for priority, item in self.items:
                print(f"  Priority {priority}: {item}")

# ============================================================================
# APPLICATION: Sliding Window Maximum (using Deque)
# ============================================================================

def sliding_window_maximum(arr, k):
    """
    Find maximum in each window of size k
    Time: O(n), Space: O(k)
    Uses monotonic deque!
    """
    print(f"\n🔍 Sliding Window Maximum: array={arr}, k={k}")
    
    dq = builtin_deque()  # Stores indices
    result = []
    
    for i in range(len(arr)):
        # Remove elements outside window
        while dq and dq[0] < i - k + 1:
            dq.popleft()
        
        # Remove smaller elements (maintain decreasing order)
        while dq and arr[dq[-1]] < arr[i]:
            dq.pop()
        
        dq.append(i)
        
        # Add to result if window is complete
        if i >= k - 1:
            result.append(arr[dq[0]])
            print(f"  Window {arr[i-k+1:i+1]} → Max: {arr[dq[0]]}")
    
    print(f"  ✅ Result: {result}")
    return result

# ============================================================================
# EXAMPLE 1: Circular Queue
# ============================================================================

print("=" * 70)
print("Example 1: Circular Queue")
print("=" * 70)

cq = CircularQueue(capacity=5)

print("\nEnqueuing 5 elements (fill queue):")
for val in [10, 20, 30, 40, 50]:
    cq.enqueue(val)
cq.display()

print("\n" + "─" * 70)
print("Try to enqueue when full:")
cq.enqueue(60)

print("\n" + "─" * 70)
print("Dequeue 2 elements:")
cq.dequeue()
cq.dequeue()
cq.display()

print("\n" + "─" * 70)
print("Enqueue 2 more (circular wrap!):")
cq.enqueue(60)
cq.enqueue(70)
cq.display()

print("\n" + "─" * 70)
print("USE CASE: Round-robin CPU scheduling")
print("Each process gets fixed time slice, then goes to back of queue")
print("─" * 70)

# ============================================================================
# EXAMPLE 2: Deque (Double-Ended Queue)
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Deque (Double-Ended Queue)")
print("=" * 70)

dq = Deque()

print("\nAdding to both ends:")
dq.add_rear('B')
dq.add_front('A')
dq.add_rear('C')
dq.add_front('Z')
dq.display()

print("\n" + "─" * 70)
print("Removing from both ends:")
dq.remove_front()
dq.remove_rear()
dq.display()

print("\n" + "─" * 70)
print("USE CASES:")
print("  • Sliding window problems")
print("  • Palindrome checking")
print("  • Undo/redo with navigation")
print("  • Browser history (forward/back)")
print("─" * 70)

# ============================================================================
# EXAMPLE 3: Priority Queue
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Priority Queue")
print("=" * 70)

pq = PriorityQueue()

print("\nEnqueuing tasks with priorities:")
pq.enqueue("Email", priority=2)
pq.enqueue("Bug Fix", priority=5)
pq.enqueue("Meeting", priority=3)
pq.enqueue("Critical Bug", priority=10)
pq.enqueue("Documentation", priority=1)
pq.display()

print("\n" + "─" * 70)
print("Processing tasks (highest priority first):")
while not pq.is_empty():
    pq.dequeue()

print("\n" + "─" * 70)
print("USE CASES:")
print("  • Task scheduling")
print("  • Dijkstra's shortest path")
print("  • A* pathfinding")
print("  • Event-driven simulation")
print("─" * 70)

# ============================================================================
# EXAMPLE 4: Sliding Window Maximum
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Sliding Window Maximum (Deque Application)")
print("=" * 70)

test_cases = [
    ([1, 3, -1, -3, 5, 3, 6, 7], 3),
    ([1, 2, 3, 4, 5], 2),
]

for arr, k in test_cases:
    sliding_window_maximum(arr, k)

print("\n" + "─" * 70)
print("ALGORITHM: Monotonic Deque")
print("  1. Maintain decreasing order in deque")
print("  2. Remove elements outside window")
print("  3. Front of deque = maximum")
print("  Time: O(n), Space: O(k)")
print("─" * 70)

# ============================================================================
# COMPARISON TABLE
# ============================================================================

print("\n" + "=" * 70)
print("Queue Variations Comparison")
print("=" * 70)

print(f"\n{'Type':<20} {'Add':<20} {'Remove':<20} {'Use Case':<30}")
print("─" * 70)
print(f"{'Regular Queue':<20} {'Rear only':<20} {'Front only':<20} {'BFS, buffering':<30}")
print(f"{'Circular Queue':<20} {'Rear (wrap)':<20} {'Front (wrap)':<20} {'Fixed buffer, round-robin':<30}")
print(f"{'Deque':<20} {'Both ends':<20} {'Both ends':<20} {'Sliding window, palindrome':<30}")
print(f"{'Priority Queue':<20} {'By priority':<20} {'Highest first':<20} {'Dijkstra, scheduling':<30}")

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Queue Type':<20} {'Enqueue':<15} {'Dequeue':<15} {'Space':<15}")
print("─" * 70)
print(f"{'Circular Queue':<20} {'O(1)':<15} {'O(1)':<15} {'O(n)':<15}")
print(f"{'Deque (list)':<20} {'O(1)/O(n)':<15} {'O(1)/O(n)':<15} {'O(n)':<15}")
print(f"{'Deque (collections)':<20} {'O(1)':<15} {'O(1)':<15} {'O(n)':<15}")
print(f"{'Priority Queue':<20} {'O(n)':<15} {'O(1)':<15} {'O(n)':<15}")
print(f"{'Priority (heap)':<20} {'O(log n)':<15} {'O(log n)':<15} {'O(n)':<15}")

print("\nNote: Use collections.deque for O(1) operations at both ends!")
print("Use heapq for O(log n) priority queue operations!")

# ============================================================================
# INTERVIEW TIPS
# ============================================================================

print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)

print("\n✅ Circular Queue:")
print("  • Explain modulo wrapping")
print("  • Handle full vs empty (size tracking)")
print("  • Use case: Fixed-size buffers")

print("\n✅ Deque:")
print("  • Operations at BOTH ends")
print("  • Use collections.deque in Python")
print("  • Sliding window pattern!")

print("\n✅ Priority Queue:")
print("  • Higher priority dequeued first")
print("  • Use heapq for efficiency")
print("  • Common in graph algorithms")

print("\n✅ Sliding Window:")
print("  • Monotonic deque pattern")
print("  • O(n) time - each element added/removed once")
print("  • Very common interview question!")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Circular Queue: Fixed size, wraps around")
print("✓ Deque: Add/remove from BOTH ends")
print("✓ Priority Queue: Highest priority first")
print("✓ Sliding Window: Use monotonic deque")
print("✓ Choose the right variation for your use case!")
print("✓ Know when to use each type!")
