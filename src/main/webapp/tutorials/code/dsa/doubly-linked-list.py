"""
Doubly Linked List - Bidirectional Traversal
Each node has BOTH next and prev pointers
More flexible but uses more memory!
"""

class Node:
    """Node in a doubly linked list"""
    def __init__(self, data):
        self.data = data
        self.next = None
        self.prev = None  # NEW: Previous pointer!

class DoublyLinkedList:
    """Doubly Linked List with bidirectional operations"""
    def __init__(self):
        self.head = None
        self.tail = None  # Keep track of tail for O(1) tail operations!
    
    def insert_at_head(self, data):
        """
        Insert at head - O(1)
        Update BOTH next and prev pointers!
        """
        print(f"\n➕ Inserting {data} at HEAD...")
        
        new_node = Node(data)
        
        if not self.head:
            # Empty list - new node is both head and tail
            self.head = new_node
            self.tail = new_node
            print(f"  ✓ Empty list - {data} is now head AND tail")
        else:
            # Link new node to current head
            new_node.next = self.head
            self.head.prev = new_node
            self.head = new_node
            print(f"  ✓ Inserted {data} at head")
    
    def insert_at_tail(self, data):
        """
        Insert at tail - O(1) with tail pointer!
        Much better than singly linked list's O(n)
        """
        print(f"\n➕ Inserting {data} at TAIL...")
        
        new_node = Node(data)
        
        if not self.tail:
            # Empty list
            self.head = new_node
            self.tail = new_node
            print(f"  ✓ Empty list - {data} is now head AND tail")
        else:
            # Link new node to current tail
            new_node.prev = self.tail
            self.tail.next = new_node
            self.tail = new_node
            print(f"  ✓ Inserted {data} at tail - O(1)!")
    
    def delete_at_head(self):
        """
        Delete at head - O(1)
        Update prev pointer of new head!
        """
        if not self.head:
            print("\n✗ Cannot delete - list is empty")
            return None
        
        deleted_value = self.head.data
        print(f"\n🗑️ Deleting HEAD ({deleted_value})...")
        
        if self.head == self.tail:
            # Only one node
            self.head = None
            self.tail = None
            print(f"  ✓ Deleted last node")
        else:
            # Move head forward
            self.head = self.head.next
            self.head.prev = None  # Important: Clear prev pointer!
            print(f"  ✓ Deleted {deleted_value}, new head is {self.head.data}")
        
        return deleted_value
    
    def delete_at_tail(self):
        """
        Delete at tail - O(1) with tail pointer!
        This is MUCH better than singly linked list's O(n)
        """
        if not self.tail:
            print("\n✗ Cannot delete - list is empty")
            return None
        
        deleted_value = self.tail.data
        print(f"\n🗑️ Deleting TAIL ({deleted_value})...")
        
        if self.head == self.tail:
            # Only one node
            self.head = None
            self.tail = None
            print(f"  ✓ Deleted last node")
        else:
            # Move tail backward - EASY with prev pointer!
            self.tail = self.tail.prev
            self.tail.next = None  # Important: Clear next pointer!
            print(f"  ✓ Deleted {deleted_value}, new tail is {self.tail.data}")
        
        return deleted_value
    
    def delete_node(self, node):
        """
        Delete specific node - O(1) if we have reference!
        This is the SUPERPOWER of doubly linked lists!
        """
        if not node:
            return
        
        print(f"\n🗑️ Deleting node with value {node.data}...")
        
        # Update previous node's next
        if node.prev:
            node.prev.next = node.next
        else:
            # Deleting head
            self.head = node.next
        
        # Update next node's prev
        if node.next:
            node.next.prev = node.prev
        else:
            # Deleting tail
            self.tail = node.prev
        
        print(f"  ✓ Deleted {node.data} in O(1)!")
    
    def print_forward(self):
        """Print list from head to tail"""
        if not self.head:
            print("List (forward): (empty)")
            return
        
        current = self.head
        elements = []
        while current:
            elements.append(str(current.data))
            current = current.next
        
        print(f"List (forward): null ← {' ↔ '.join(elements)} → null")
    
    def print_backward(self):
        """Print list from tail to head - ONLY possible with doubly linked list!"""
        if not self.tail:
            print("List (backward): (empty)")
            return
        
        current = self.tail
        elements = []
        while current:
            elements.append(str(current.data))
            current = current.prev
        
        print(f"List (backward): null ← {' ↔ '.join(elements)} → null")
    
    def reverse(self):
        """
        Reverse list - Just swap next and prev pointers!
        Much simpler than singly linked list!
        """
        print("\n🔄 Reversing list...")
        
        if not self.head:
            return
        
        current = self.head
        
        # Swap head and tail
        self.head, self.tail = self.tail, self.head
        
        # Swap next and prev for each node
        while current:
            # Swap next and prev
            current.next, current.prev = current.prev, current.next
            # Move to next (which is now prev!)
            current = current.prev
        
        print("✓ Reversed!")
    
    def find(self, value):
        """Find node with value"""
        current = self.head
        position = 0
        
        while current:
            if current.data == value:
                return current, position
            current = current.next
            position += 1
        
        return None, -1

# Example 1: Basic Operations
print("=" * 70)
print("Example 1: Basic Doubly Linked List Operations")
print("=" * 70)

dll = DoublyLinkedList()

print("\nInserting at head:")
for val in [3, 2, 1]:
    dll.insert_at_head(val)
    dll.print_forward()

print("\n" + "─" * 70)
print("\nInserting at tail:")
for val in [4, 5, 6]:
    dll.insert_at_tail(val)
    dll.print_forward()

print("\n" + "─" * 70)
print("\nBidirectional traversal:")
dll.print_forward()
dll.print_backward()

# Example 2: Delete Operations
print("\n" + "=" * 70)
print("Example 2: Delete Operations - O(1) at BOTH ends!")
print("=" * 70)

dll2 = DoublyLinkedList()
for val in [10, 20, 30, 40, 50]:
    dll2.insert_at_tail(val)

print("\nOriginal list:")
dll2.print_forward()

dll2.delete_at_head()
dll2.print_forward()

dll2.delete_at_tail()
dll2.print_forward()

print("\n" + "─" * 70)
print("KEY ADVANTAGE: Delete at tail is O(1)!")
print("Singly linked list: O(n) - must find second-to-last")
print("Doubly linked list: O(1) - just use prev pointer!")
print("─" * 70)

# Example 3: Delete Specific Node
print("\n" + "=" * 70)
print("Example 3: Delete Specific Node - O(1) Superpower!")
print("=" * 70)

dll3 = DoublyLinkedList()
for val in [100, 200, 300, 400, 500]:
    dll3.insert_at_tail(val)

print("\nOriginal list:")
dll3.print_forward()

# Find and delete node with value 300
node, pos = dll3.find(300)
if node:
    print(f"\nFound {node.data} at position {pos}")
    dll3.delete_node(node)
    dll3.print_forward()

print("\n" + "─" * 70)
print("SUPERPOWER: If you have a reference to a node,")
print("you can delete it in O(1) - no traversal needed!")
print("This is IMPOSSIBLE with singly linked list!")
print("─" * 70)

# Example 4: Reverse
print("\n" + "=" * 70)
print("Example 4: Reverse - Simpler than Singly Linked List!")
print("=" * 70)

dll4 = DoublyLinkedList()
for val in [1, 2, 3, 4, 5]:
    dll4.insert_at_tail(val)

print("\nOriginal list:")
dll4.print_forward()

dll4.reverse()

print("\nReversed list:")
dll4.print_forward()

print("\n" + "─" * 70)
print("SIMPLER: Just swap next and prev pointers!")
print("Singly linked list: Need 3-pointer technique")
print("Doubly linked list: Just swap pointers!")
print("─" * 70)

# Comparison Table
print("\n" + "=" * 70)
print("Singly vs Doubly Linked List Comparison")
print("=" * 70)
print(f"{'Operation':<30} {'Singly':<15} {'Doubly':<15} {'Winner':<15}")
print("-" * 70)
print(f"{'Insert at head':<30} {'O(1)':<15} {'O(1)':<15} {'Tie =':<15}")
print(f"{'Insert at tail':<30} {'O(n)':<15} {'O(1) ✓':<15} {'Doubly!':<15}")
print(f"{'Delete at head':<30} {'O(1)':<15} {'O(1)':<15} {'Tie =':<15}")
print(f"{'Delete at tail':<30} {'O(n)':<15} {'O(1) ✓':<15} {'Doubly!':<15}")
print(f"{'Delete specific node':<30} {'O(n)':<15} {'O(1) ✓':<15} {'Doubly!':<15}")
print(f"{'Traverse backward':<30} {'Impossible':<15} {'O(n) ✓':<15} {'Doubly!':<15}")
print(f"{'Reverse':<30} {'O(n)':<15} {'O(n)':<15} {'Tie =':<15}")
print(f"{'Memory per node':<30} {'2 pointers':<15} {'3 pointers':<15} {'Singly':<15}")

# Complexity Analysis
print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)
print(f"{'Operation':<30} {'Time':<15} {'Space':<15}")
print("-" * 70)
print(f"{'Insert at head':<30} {'O(1) ✓':<15} {'O(1)':<15}")
print(f"{'Insert at tail':<30} {'O(1) ✓':<15} {'O(1)':<15}")
print(f"{'Delete at head':<30} {'O(1) ✓':<15} {'O(1)':<15}")
print(f"{'Delete at tail':<30} {'O(1) ✓':<15} {'O(1)':<15}")
print(f"{'Delete specific node':<30} {'O(1) ✓':<15} {'O(1)':<15}")
print(f"{'Search':<30} {'O(n)':<15} {'O(1)':<15}")
print(f"{'Reverse':<30} {'O(n)':<15} {'O(1)':<15}")
print(f"{'Space per node':<30} {'-':<15} {'O(1) extra':<15}")

# Use Cases
print("\n" + "=" * 70)
print("When to Use Doubly Linked List")
print("=" * 70)
print("\n✅ USE DOUBLY LINKED LIST WHEN:")
print("  • Need to traverse backward")
print("  • Need O(1) delete at tail")
print("  • Need O(1) delete of specific node (with reference)")
print("  • Implementing deque (double-ended queue)")
print("  • Browser history (back/forward)")
print("  • Undo/Redo functionality")
print("  • LRU Cache implementation")

print("\n❌ USE SINGLY LINKED LIST WHEN:")
print("  • Only need forward traversal")
print("  • Memory is very limited")
print("  • Only insert/delete at head")
print("  • Implementing stack or simple queue")

# Interview Tips
print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)
print("✅ Doubly linked lists are EASIER for many operations!")
print("✅ Always update BOTH next and prev pointers")
print("✅ Don't forget to update head AND tail")
print("✅ O(1) delete is the key advantage")
print("✅ Common in real systems: LRU cache, browser history")

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)
print("✓ Each node has next AND prev pointers")
print("✓ Can traverse in BOTH directions")
print("✓ O(1) operations at BOTH ends (with tail pointer)")
print("✓ O(1) delete of specific node (if you have reference)")
print("✓ Trade-off: More memory for more flexibility")
print("✓ Perfect for deque, LRU cache, browser history")
