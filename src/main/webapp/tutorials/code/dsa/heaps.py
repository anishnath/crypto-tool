"""
Heaps & Priority Queue
Efficient priority-based data structure
"""

# ============================================================================
# MIN HEAP IMPLEMENTATION
# ============================================================================

class MinHeap:
    """
    Min Heap - Parent is smaller than children
    Complete binary tree stored in array
    """
    
    def __init__(self):
        self.heap = []
    
    def parent(self, i):
        """Get parent index"""
        return (i - 1) // 2
    
    def left_child(self, i):
        """Get left child index"""
        return 2 * i + 1
    
    def right_child(self, i):
        """Get right child index"""
        return 2 * i + 2
    
    def swap(self, i, j):
        """Swap two elements"""
        self.heap[i], self.heap[j] = self.heap[j], self.heap[i]
    
    def insert(self, value):
        """
        Insert value into heap
        Time: O(log n), Space: O(1)
        """
        print(f"\n➕ Inserting {value}")
        
        # Add to end
        self.heap.append(value)
        print(f"   Added to end: {self.heap}")
        
        # Bubble up
        self._heapify_up(len(self.heap) - 1)
        print(f"   After heapify up: {self.heap}")
    
    def _heapify_up(self, i):
        """Bubble up to maintain heap property"""
        while i > 0:
            parent_idx = self.parent(i)
            
            if self.heap[i] < self.heap[parent_idx]:
                print(f"   Swap {self.heap[i]} with parent {self.heap[parent_idx]}")
                self.swap(i, parent_idx)
                i = parent_idx
            else:
                break
    
    def extract_min(self):
        """
        Remove and return minimum (root)
        Time: O(log n), Space: O(1)
        """
        if not self.heap:
            return None
        
        if len(self.heap) == 1:
            return self.heap.pop()
        
        # Save min
        min_val = self.heap[0]
        print(f"\n🔽 Extracting min: {min_val}")
        
        # Move last to root
        self.heap[0] = self.heap.pop()
        print(f"   Moved last to root: {self.heap}")
        
        # Bubble down
        self._heapify_down(0)
        print(f"   After heapify down: {self.heap}")
        
        return min_val
    
    def _heapify_down(self, i):
        """Bubble down to maintain heap property"""
        while True:
            smallest = i
            left = self.left_child(i)
            right = self.right_child(i)
            
            # Find smallest among node and children
            if left < len(self.heap) and self.heap[left] < self.heap[smallest]:
                smallest = left
            
            if right < len(self.heap) and self.heap[right] < self.heap[smallest]:
                smallest = right
            
            # If smallest is not current node, swap and continue
            if smallest != i:
                print(f"   Swap {self.heap[i]} with {self.heap[smallest]}")
                self.swap(i, smallest)
                i = smallest
            else:
                break
    
    def peek(self):
        """Get minimum without removing"""
        return self.heap[0] if self.heap else None
    
    def size(self):
        """Get heap size"""
        return len(self.heap)
    
    def is_empty(self):
        """Check if heap is empty"""
        return len(self.heap) == 0

# ============================================================================
# MAX HEAP IMPLEMENTATION
# ============================================================================

class MaxHeap:
    """
    Max Heap - Parent is larger than children
    """
    
    def __init__(self):
        self.heap = []
    
    def parent(self, i):
        return (i - 1) // 2
    
    def left_child(self, i):
        return 2 * i + 1
    
    def right_child(self, i):
        return 2 * i + 2
    
    def swap(self, i, j):
        self.heap[i], self.heap[j] = self.heap[j], self.heap[i]
    
    def insert(self, value):
        """Insert value into max heap"""
        self.heap.append(value)
        self._heapify_up(len(self.heap) - 1)
    
    def _heapify_up(self, i):
        """Bubble up for max heap"""
        while i > 0:
            parent_idx = self.parent(i)
            
            if self.heap[i] > self.heap[parent_idx]:
                self.swap(i, parent_idx)
                i = parent_idx
            else:
                break
    
    def extract_max(self):
        """Remove and return maximum"""
        if not self.heap:
            return None
        
        if len(self.heap) == 1:
            return self.heap.pop()
        
        max_val = self.heap[0]
        self.heap[0] = self.heap.pop()
        self._heapify_down(0)
        
        return max_val
    
    def _heapify_down(self, i):
        """Bubble down for max heap"""
        while True:
            largest = i
            left = self.left_child(i)
            right = self.right_child(i)
            
            if left < len(self.heap) and self.heap[left] > self.heap[largest]:
                largest = left
            
            if right < len(self.heap) and self.heap[right] > self.heap[largest]:
                largest = right
            
            if largest != i:
                self.swap(i, largest)
                i = largest
            else:
                break
    
    def peek(self):
        return self.heap[0] if self.heap else None

# ============================================================================
# PRIORITY QUEUE USING HEAP
# ============================================================================

class PriorityQueue:
    """
    Priority Queue - Lower number = higher priority
    Uses min heap internally
    """
    
    def __init__(self):
        self.heap = MinHeap()
    
    def enqueue(self, item, priority):
        """Add item with priority"""
        self.heap.insert((priority, item))
        print(f"   Enqueued: {item} (priority {priority})")
    
    def dequeue(self):
        """Remove and return highest priority item"""
        if self.heap.is_empty():
            return None
        
        priority, item = self.heap.extract_min()
        print(f"   Dequeued: {item} (priority {priority})")
        return item
    
    def is_empty(self):
        return self.heap.is_empty()

# ============================================================================
# HEAPIFY - BUILD HEAP FROM ARRAY
# ============================================================================

def heapify(arr):
    """
    Build min heap from array
    Time: O(n), Space: O(1)
    """
    n = len(arr)
    
    print(f"\n🔨 Building heap from: {arr}")
    
    # Start from last non-leaf node
    for i in range(n // 2 - 1, -1, -1):
        _heapify_down_array(arr, n, i)
    
    print(f"   Result: {arr}")
    return arr

def _heapify_down_array(arr, n, i):
    """Helper for heapify"""
    while True:
        smallest = i
        left = 2 * i + 1
        right = 2 * i + 2
        
        if left < n and arr[left] < arr[smallest]:
            smallest = left
        
        if right < n and arr[right] < arr[smallest]:
            smallest = right
        
        if smallest != i:
            arr[i], arr[smallest] = arr[smallest], arr[i]
            i = smallest
        else:
            break

# ============================================================================
# HEAP SORT
# ============================================================================

def heap_sort(arr):
    """
    Sort array using heap
    Time: O(n log n), Space: O(1)
    """
    print(f"\n📊 Heap Sort: {arr}")
    
    n = len(arr)
    
    # Build max heap
    for i in range(n // 2 - 1, -1, -1):
        _heapify_down_max(arr, n, i)
    
    # Extract elements one by one
    for i in range(n - 1, 0, -1):
        arr[0], arr[i] = arr[i], arr[0]
        _heapify_down_max(arr, i, 0)
    
    print(f"   Sorted: {arr}")
    return arr

def _heapify_down_max(arr, n, i):
    """Helper for heap sort (max heap)"""
    while True:
        largest = i
        left = 2 * i + 1
        right = 2 * i + 2
        
        if left < n and arr[left] > arr[largest]:
            largest = left
        
        if right < n and arr[right] > arr[largest]:
            largest = right
        
        if largest != i:
            arr[i], arr[largest] = arr[largest], arr[i]
            i = largest
        else:
            break

# ============================================================================
# EXAMPLE 1: Min Heap Operations
# ============================================================================

print("=" * 70)
print("Example 1: Min Heap Operations")
print("=" * 70)

min_heap = MinHeap()

# Insert values
values = [5, 3, 7, 1, 9, 4]
for val in values:
    min_heap.insert(val)

print(f"\n📊 Final heap: {min_heap.heap}")
print(f"Min element: {min_heap.peek()}")

# Extract min
print("\nExtracting minimums:")
while not min_heap.is_empty():
    print(f"  {min_heap.extract_min()}")

# ============================================================================
# EXAMPLE 2: Priority Queue
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Priority Queue (Task Scheduler)")
print("=" * 70)

pq = PriorityQueue()

print("\nAdding tasks:")
pq.enqueue("Critical bug fix", 1)
pq.enqueue("Code review", 3)
pq.enqueue("Security patch", 1)
pq.enqueue("Documentation", 5)
pq.enqueue("Feature request", 4)

print("\nProcessing tasks by priority:")
while not pq.is_empty():
    task = pq.dequeue()

# ============================================================================
# EXAMPLE 3: Heapify
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Build Heap from Array")
print("=" * 70)

arr = [9, 5, 6, 2, 3, 7, 1, 4, 8]
heapify(arr)

# ============================================================================
# EXAMPLE 4: Heap Sort
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Heap Sort")
print("=" * 70)

arr = [64, 34, 25, 12, 22, 11, 90]
heap_sort(arr)

# ============================================================================
# COMPLEXITY SUMMARY
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Summary")
print("=" * 70)

print(f"\n{'Operation':<25} {'Time':<20} {'Space':<20}")
print("─" * 65)
print(f"{'Insert':<25} {'O(log n)':<20} {'O(1)':<20}")
print(f"{'Extract min/max':<25} {'O(log n)':<20} {'O(1)':<20}")
print(f"{'Peek':<25} {'O(1)':<20} {'O(1)':<20}")
print(f"{'Build heap (heapify)':<25} {'O(n)':<20} {'O(1)':<20}")
print(f"{'Heap sort':<25} {'O(n log n)':<20} {'O(1)':<20}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Heap is a complete binary tree")
print("✓ Stored efficiently in array")
print("✓ Min heap: parent < children")
print("✓ Max heap: parent > children")
print("✓ Insert and extract: O(log n)")
print("✓ Build heap: O(n) - faster than n inserts!")
print("✓ Perfect for priority queues")
print("✓ Used in: Dijkstra, heap sort, top K problems")
