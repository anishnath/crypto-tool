"""
Queue Basics - FIFO (First In, First Out)
Two implementations: Circular Array and Linked List
Essential for BFS, scheduling, buffering!
"""

# ============================================================================
# IMPLEMENTATION 1: Queue with Circular Array
# ============================================================================

class QueueArray:
    """Queue implementation using circular array"""
    
    def __init__(self, capacity=5):
        self.items = [None] * capacity
        self.capacity = capacity
        self.front = 0
        self.rear = -1
        self.size = 0
    
    def enqueue(self, item):
        """
        Add item to rear - O(1)
        """
        if self.is_full():
            print(f"✗ Cannot enqueue {item} - queue is full!")
            return False
        
        self.rear = (self.rear + 1) % self.capacity  # Circular wrap
        self.items[self.rear] = item
        self.size += 1
        print(f"➕ Enqueued {item} at rear (index {self.rear})")
        return True
    
    def dequeue(self):
        """
        Remove item from front - O(1)
        """
        if self.is_empty():
            print("✗ Cannot dequeue - queue is empty!")
            return None
        
        item = self.items[self.front]
        self.items[self.front] = None  # Clear slot
        self.front = (self.front + 1) % self.capacity  # Circular wrap
        self.size -= 1
        print(f"➖ Dequeued {item} from front")
        return item
    
    def peek(self):
        """View front item without removing - O(1)"""
        if self.is_empty():
            return None
        return self.items[self.front]
    
    def is_empty(self):
        """Check if queue is empty - O(1)"""
        return self.size == 0
    
    def is_full(self):
        """Check if queue is full - O(1)"""
        return self.size == self.capacity
    
    def get_size(self):
        """Get queue size - O(1)"""
        return self.size
    
    def display(self):
        """Display queue contents"""
        if self.is_empty():
            print("Queue: (empty)")
            return
        
        print("\nQueue (front to rear):")
        print(f"  Array: {self.items}")
        print(f"  Front index: {self.front}, Rear index: {self.rear}")
        
        # Show actual queue order
        elements = []
        idx = self.front
        for _ in range(self.size):
            elements.append(str(self.items[idx]))
            idx = (idx + 1) % self.capacity
        
        print(f"  FRONT → [{' → '.join(elements)}] → REAR")
        print()

# ============================================================================
# IMPLEMENTATION 2: Queue with Linked List
# ============================================================================

class Node:
    """Node for linked list-based queue"""
    def __init__(self, data):
        self.data = data
        self.next = None

class QueueLinkedList:
    """Queue implementation using linked list"""
    
    def __init__(self):
        self.front = None
        self.rear = None
        self.size = 0
    
    def enqueue(self, item):
        """
        Add item to rear - O(1)
        """
        new_node = Node(item)
        
        if self.is_empty():
            self.front = new_node
            self.rear = new_node
        else:
            self.rear.next = new_node
            self.rear = new_node
        
        self.size += 1
        print(f"➕ Enqueued {item} at rear")
    
    def dequeue(self):
        """
        Remove item from front - O(1)
        """
        if self.is_empty():
            print("✗ Cannot dequeue - queue is empty!")
            return None
        
        item = self.front.data
        self.front = self.front.next
        
        if self.front is None:  # Queue became empty
            self.rear = None
        
        self.size -= 1
        print(f"➖ Dequeued {item} from front")
        return item
    
    def peek(self):
        """View front item without removing - O(1)"""
        if self.is_empty():
            return None
        return self.front.data
    
    def is_empty(self):
        """Check if queue is empty - O(1)"""
        return self.front is None
    
    def get_size(self):
        """Get queue size - O(1)"""
        return self.size
    
    def display(self):
        """Display queue contents"""
        if self.is_empty():
            print("Queue: (empty)")
            return
        
        print("\nQueue (front to rear):")
        current = self.front
        elements = []
        while current:
            elements.append(str(current.data))
            current = current.next
        
        print(f"  FRONT → [{' → '.join(elements)}] → REAR")
        print()

# ============================================================================
# EXAMPLE 1: Circular Array Queue
# ============================================================================

print("=" * 70)
print("Example 1: Queue with Circular Array")
print("=" * 70)

queue_arr = QueueArray(capacity=5)

print("\nEnqueuing elements:")
for val in [10, 20, 30, 40, 50]:
    queue_arr.enqueue(val)
    queue_arr.display()

print("─" * 70)
print(f"Front element: {queue_arr.peek()}")
print(f"Queue size: {queue_arr.get_size()}")
print(f"Is full? {queue_arr.is_full()}")

print("\n" + "─" * 70)
print("Trying to enqueue when full:")
queue_arr.enqueue(60)

print("\n" + "─" * 70)
print("Dequeuing 2 elements:")
queue_arr.dequeue()
queue_arr.dequeue()
queue_arr.display()

print("─" * 70)
print("Enqueuing 2 more (circular wrap!):")
queue_arr.enqueue(60)
queue_arr.enqueue(70)
queue_arr.display()

print("─" * 70)
print("NOTICE: Rear wrapped around to beginning!")
print("This is the power of circular arrays!")
print("─" * 70)

# ============================================================================
# EXAMPLE 2: Linked List Queue
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Queue with Linked List")
print("=" * 70)

queue_ll = QueueLinkedList()

print("\nEnqueuing elements:")
for val in ['A', 'B', 'C', 'D', 'E']:
    queue_ll.enqueue(val)
    queue_ll.display()

print("─" * 70)
print(f"Front element: {queue_ll.peek()}")
print(f"Queue size: {queue_ll.get_size()}")

print("\n" + "─" * 70)
print("Dequeuing 3 elements:")
for _ in range(3):
    queue_ll.dequeue()
    queue_ll.display()

# ============================================================================
# EXAMPLE 3: FIFO Demonstration
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: FIFO (First In, First Out) Demonstration")
print("=" * 70)

queue = QueueArray(capacity=5)

print("\nScenario: Customer Service Queue")
print("Customers arrive in order:\n")

customers = ["Alice", "Bob", "Charlie", "Diana"]

print("Customers joining queue:")
for customer in customers:
    queue.enqueue(customer)
    print(f"  → {customer} joined the queue")

queue.display()

print("Serving customers (FIFO):")
while not queue.is_empty():
    customer = queue.dequeue()
    print(f"  ← Serving {customer}")

print("\nNotice: First customer (Alice) served first!")
print("This is FIFO in action!")

# ============================================================================
# EXAMPLE 4: Edge Cases
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Edge Cases")
print("=" * 70)

edge_queue = QueueArray(capacity=3)

print("\n1. Dequeue from empty queue:")
edge_queue.dequeue()

print("\n2. Peek at empty queue:")
result = edge_queue.peek()
print(f"   Result: {result}")

print("\n3. Fill queue completely:")
edge_queue.enqueue(1)
edge_queue.enqueue(2)
edge_queue.enqueue(3)
edge_queue.display()

print("4. Try to enqueue when full:")
edge_queue.enqueue(4)

print("\n5. Dequeue all:")
while not edge_queue.is_empty():
    edge_queue.dequeue()
edge_queue.display()

# ============================================================================
# COMPARISON: Array vs Linked List
# ============================================================================

print("\n" + "=" * 70)
print("Circular Array vs Linked List Comparison")
print("=" * 70)

print(f"\n{'Operation':<20} {'Circular Array':<20} {'Linked List':<20} {'Winner':<15}")
print("─" * 70)
print(f"{'Enqueue':<20} {'O(1)':<20} {'O(1)':<20} {'Tie':<15}")
print(f"{'Dequeue':<20} {'O(1)':<20} {'O(1)':<20} {'Tie':<15}")
print(f"{'Peek':<20} {'O(1)':<20} {'O(1)':<20} {'Tie':<15}")
print(f"{'Memory overhead':<20} {'Less (fixed)':<20} {'More (pointers)':<20} {'Array':<15}")
print(f"{'Cache performance':<20} {'Better':<20} {'Worse':<20} {'Array':<15}")
print(f"{'Size limit':<20} {'Fixed':<20} {'Dynamic':<20} {'Linked List':<15}")
print(f"{'Circular wrap':<20} {'Needed':<20} {'Not needed':<20} {'Linked List':<15}")

# ============================================================================
# QUEUE VS STACK
# ============================================================================

print("\n" + "=" * 70)
print("Queue vs Stack Comparison")
print("=" * 70)

print(f"\n{'Aspect':<25} {'Queue (FIFO)':<25} {'Stack (LIFO)':<25}")
print("─" * 70)
print(f"{'Principle':<25} {'First In, First Out':<25} {'Last In, First Out':<25}")
print(f"{'Add operation':<25} {'Enqueue (rear)':<25} {'Push (top)':<25}")
print(f"{'Remove operation':<25} {'Dequeue (front)':<25} {'Pop (top)':<25}")
print(f"{'Access points':<25} {'Two (front & rear)':<25} {'One (top)':<25}")
print(f"{'Real-world analogy':<25} {'Line at store':<25} {'Stack of plates':<25}")
print(f"{'Common use':<25} {'BFS, scheduling':<25} {'DFS, undo/redo':<25}")

# ============================================================================
# REAL-WORLD APPLICATIONS
# ============================================================================

print("\n" + "=" * 70)
print("Real-World Applications of Queues")
print("=" * 70)

print("\n1. Breadth-First Search (BFS)")
print("   • Graph/tree traversal level by level")
print("   • Shortest path in unweighted graphs")

print("\n2. Task Scheduling")
print("   • CPU scheduling (Round Robin)")
print("   • Print queue")
print("   • Request handling")

print("\n3. Buffering")
print("   • IO buffers")
print("   • Streaming data")
print("   • Network packets")

print("\n4. Customer Service")
print("   • Call centers")
print("   • Ticket queues")
print("   • First come, first served")

print("\n5. Asynchronous Processing")
print("   • Message queues")
print("   • Job queues")
print("   • Event handling")

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Operation':<20} {'Time Complexity':<25} {'Space Complexity':<20}")
print("─" * 70)
print(f"{'Enqueue':<20} {'O(1)':<25} {'O(1)':<20}")
print(f"{'Dequeue':<20} {'O(1)':<25} {'O(1)':<20}")
print(f"{'Peek':<20} {'O(1)':<25} {'O(1)':<20}")
print(f"{'Is Empty':<20} {'O(1)':<25} {'O(1)':<20}")
print(f"{'Size':<20} {'O(1)':<25} {'O(1)':<20}")

print("\nNote: All operations are O(1) - constant time!")
print("Circular array prevents shifting elements!")

# ============================================================================
# INTERVIEW TIPS
# ============================================================================

print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)

print("\n✅ Always mention FIFO principle!")
print("✅ Know both circular array and linked list implementations")
print("✅ Circular array: explain front/rear wrapping")
print("✅ All operations are O(1) - emphasize this!")
print("✅ Queue vs Stack: know the differences")
print("✅ Common follow-up: Implement using stacks")
print("✅ Know applications: BFS, scheduling, buffering")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Queue is FIFO - First In, First Out")
print("✓ All operations are O(1) - super efficient!")
print("✓ Two implementations: circular array and linked list")
print("✓ Circular array: use modulo for wrapping")
print("✓ Linked list: track both front and rear")
print("✓ Used everywhere: BFS, scheduling, buffering")
print("✓ Opposite of stack (LIFO vs FIFO)!")
