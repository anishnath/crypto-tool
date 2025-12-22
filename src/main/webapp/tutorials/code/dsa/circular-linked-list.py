"""
Circular Linked List - The Last Node Points Back to First!
No null termination - forms a circle
Perfect for round-robin scheduling and circular buffers!
"""

class Node:
    """Node in a circular linked list"""
    def __init__(self, data):
        self.data = data
        self.next = None

class CircularLinkedList:
    """Circular Linked List - last node points to first!"""
    def __init__(self):
        self.head = None
    
    def insert_at_head(self, data):
        """
        Insert at head - O(n) to find last node
        (unless we keep tail pointer)
        """
        print(f"\n➕ Inserting {data} at HEAD...")
        
        new_node = Node(data)
        
        if not self.head:
            # Empty list - node points to itself!
            new_node.next = new_node
            self.head = new_node
            print(f"  ✓ First node - points to itself!")
        else:
            # Find last node
            last = self.head
            while last.next != self.head:
                last = last.next
            
            # Insert at head
            new_node.next = self.head
            last.next = new_node
            self.head = new_node
            print(f"  ✓ Inserted {data} at head, last node now points to it")
    
    def insert_at_tail(self, data):
        """
        Insert at tail - O(n) to find last node
        """
        print(f"\n➕ Inserting {data} at TAIL...")
        
        new_node = Node(data)
        
        if not self.head:
            # Empty list
            new_node.next = new_node
            self.head = new_node
            print(f"  ✓ First node - points to itself!")
        else:
            # Find last node
            last = self.head
            while last.next != self.head:
                last = last.next
            
            # Insert at tail
            last.next = new_node
            new_node.next = self.head
            print(f"  ✓ Inserted {data} at tail, points back to head")
    
    def delete_at_head(self):
        """
        Delete at head - O(n) to find last node
        """
        if not self.head:
            print("\n✗ Cannot delete - list is empty")
            return None
        
        deleted_value = self.head.data
        print(f"\n🗑️ Deleting HEAD ({deleted_value})...")
        
        if self.head.next == self.head:
            # Only one node
            self.head = None
            print(f"  ✓ Deleted last node - list is empty")
        else:
            # Find last node
            last = self.head
            while last.next != self.head:
                last = last.next
            
            # Delete head
            last.next = self.head.next
            self.head = self.head.next
            print(f"  ✓ Deleted {deleted_value}, last node now points to new head")
        
        return deleted_value
    
    def print_list(self, max_nodes=20):
        """Print list - careful not to infinite loop!"""
        if not self.head:
            print("List: (empty)")
            return
        
        current = self.head
        elements = []
        count = 0
        
        # Traverse once around the circle
        while True:
            elements.append(str(current.data))
            current = current.next
            count += 1
            
            if current == self.head or count >= max_nodes:
                break
        
        print(f"List: {' → '.join(elements)} → (back to {self.head.data})")
    
    def traverse_n_times(self, n):
        """
        Traverse the circle n times
        Shows the circular nature!
        """
        if not self.head:
            print("List is empty")
            return
        
        print(f"\n🔄 Traversing circle {n} times:")
        current = self.head
        count = 0
        
        # Count nodes in circle
        temp = self.head
        circle_size = 1
        while temp.next != self.head:
            circle_size += 1
            temp = temp.next
        
        print(f"  Circle has {circle_size} nodes")
        
        # Traverse n times around
        for i in range(n * circle_size):
            print(f"  Step {i+1}: {current.data}", end="")
            if (i + 1) % circle_size == 0:
                print(" (completed one circle!)")
            else:
                print()
            current = current.next
    
    def is_circular(self):
        """
        Check if list is circular
        Uses Floyd's algorithm!
        """
        print("\n🔍 Checking if list is circular...")
        
        if not self.head:
            return False
        
        slow = self.head
        fast = self.head
        
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            
            if slow == fast:
                print("✅ List is circular!")
                return True
        
        print("✗ List is not circular")
        return False
    
    def split_into_two(self):
        """
        Split circular list into two halves
        Both halves are circular!
        """
        if not self.head or self.head.next == self.head:
            print("\n✗ Cannot split - need at least 2 nodes")
            return None, None
        
        print("\n✂️ Splitting into two circular lists...")
        
        # Find middle using slow-fast
        slow = self.head
        fast = self.head
        
        while fast.next != self.head and fast.next.next != self.head:
            slow = slow.next
            fast = fast.next.next
        
        # Split
        head1 = self.head
        head2 = slow.next
        
        # Make first half circular
        slow.next = head1
        
        # Make second half circular
        current = head2
        while current.next != self.head:
            current = current.next
        current.next = head2
        
        print(f"✓ Split into two circular lists!")
        print(f"  First half starts at: {head1.data}")
        print(f"  Second half starts at: {head2.data}")
        
        return head1, head2

# Example 1: Basic Circular List
print("=" * 70)
print("Example 1: Basic Circular Linked List")
print("=" * 70)

cll = CircularLinkedList()

print("\nInserting nodes:")
for val in [10, 20, 30, 40]:
    cll.insert_at_tail(val)
    cll.print_list()

print("\n" + "─" * 70)
print("KEY FEATURE: Last node points back to first!")
print("No null termination - forms a complete circle!")
print("─" * 70)

# Example 2: Circular Nature
print("\n" + "=" * 70)
print("Example 2: Demonstrating Circular Nature")
print("=" * 70)

cll2 = CircularLinkedList()
for val in [1, 2, 3]:
    cll2.insert_at_tail(val)

print("\nOriginal list:")
cll2.print_list()

cll2.traverse_n_times(3)

print("\n" + "─" * 70)
print("CIRCULAR: You can keep going around forever!")
print("Perfect for: Round-robin scheduling, circular buffers")
print("─" * 70)

# Example 3: Detect Circular
print("\n" + "=" * 70)
print("Example 3: Detecting Circular List")
print("=" * 70)

cll3 = CircularLinkedList()
for val in [100, 200, 300]:
    cll3.insert_at_tail(val)

print("\nList:")
cll3.print_list()

cll3.is_circular()

print("\n" + "─" * 70)
print("DETECTION: Use Floyd's algorithm!")
print("Circular list: Pointers will always meet")
print("─" * 70)

# Example 4: Split
print("\n" + "=" * 70)
print("Example 4: Split into Two Circular Lists")
print("=" * 70)

cll4 = CircularLinkedList()
for val in [1, 2, 3, 4, 5, 6]:
    cll4.insert_at_tail(val)

print("\nOriginal list:")
cll4.print_list()

head1, head2 = cll4.split_into_two()

print("\nFirst half:")
temp = head1
elements = []
while True:
    elements.append(str(temp.data))
    temp = temp.next
    if temp == head1:
        break
print(f"  {' → '.join(elements)} → (back to {head1.data})")

print("\nSecond half:")
temp = head2
elements = []
while True:
    elements.append(str(temp.data))
    temp = temp.next
    if temp == head2:
        break
print(f"  {' → '.join(elements)} → (back to {head2.data})")

# Comparison with Other Lists
print("\n" + "=" * 70)
print("Circular vs Singly vs Doubly Comparison")
print("=" * 70)
print(f"{'Feature':<30} {'Singly':<15} {'Doubly':<15} {'Circular':<15}")
print("-" * 70)
print(f"{'Last node points to':<30} {'null':<15} {'null':<15} {'head ✓':<15}")
print(f"{'Can loop forever':<30} {'No':<15} {'No':<15} {'Yes ✓':<15}")
print(f"{'Insert at head':<30} {'O(1)':<15} {'O(1)':<15} {'O(n)':<15}")
print(f"{'Insert at tail':<30} {'O(n)':<15} {'O(1)':<15} {'O(n)':<15}")
print(f"{'Traverse backward':<30} {'No':<15} {'Yes ✓':<15} {'No':<15}")
print(f"{'Memory per node':<30} {'2 ptrs':<15} {'3 ptrs':<15} {'2 ptrs ✓':<15}")

# Use Cases
print("\n" + "=" * 70)
print("When to Use Circular Linked List")
print("=" * 70)
print("\n✅ USE CIRCULAR LINKED LIST WHEN:")
print("  • Round-robin scheduling (CPU, network)")
print("  • Circular buffers (audio, video streaming)")
print("  • Multiplayer games (turn-based)")
print("  • Music playlist (repeat mode)")
print("  • Josephus problem")
print("  • Implementing circular queue")

print("\n❌ DON'T USE WHEN:")
print("  • Need null termination for logic")
print("  • Frequent insert/delete at ends")
print("  • Need backward traversal (use doubly)")
print("  • Risk of infinite loops is high")

# Complexity Analysis
print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)
print(f"{'Operation':<30} {'Time':<15} {'Space':<15}")
print("-" * 70)
print(f"{'Insert at head':<30} {'O(n)':<15} {'O(1)':<15}")
print(f"{'Insert at tail':<30} {'O(n)':<15} {'O(1)':<15}")
print(f"{'Delete at head':<30} {'O(n)':<15} {'O(1)':<15}")
print(f"{'Traverse once':<30} {'O(n)':<15} {'O(1)':<15}")
print(f"{'Detect circular':<30} {'O(n)':<15} {'O(1)':<15}")
print(f"{'Split into two':<30} {'O(n)':<15} {'O(1)':<15}")

print("\nNote: With tail pointer, insert/delete at tail becomes O(1)!")

# Interview Tips
print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)
print("✅ Always check for infinite loops!")
print("✅ Use condition: current.next != head (not != null)")
print("✅ Floyd's algorithm works for detection")
print("✅ Common in OS scheduling problems")
print("✅ Josephus problem is classic circular list question")

print("\n" + "=" * 70)
print("Common Interview Problems")
print("=" * 70)
print("1. Josephus problem (eliminate every kth person)")
print("2. Round-robin scheduling")
print("3. Split circular list into two")
print("4. Detect if list is circular")
print("5. Convert singly to circular")
print("6. Find start of circular part")

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)
print("✓ Last node points to head (no null!)")
print("✓ Can traverse forever - forms complete circle")
print("✓ Perfect for round-robin and circular buffers")
print("✓ Must be careful to avoid infinite loops")
print("✓ Use condition: current.next != head")
print("✓ Josephus problem is THE classic circular list problem")
