"""
Linked List Cycle Detection - Floyd's Tortoise and Hare Algorithm
Detect, find start, and remove cycles in O(n) time, O(1) space
Another top interview question!
"""

class Node:
    """Node in a singly linked list"""
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    """Linked List with cycle detection operations"""
    def __init__(self):
        self.head = None
    
    def insert_at_tail(self, data):
        """Insert at end"""
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return new_node
        
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node
        return new_node
    
    def create_cycle(self, pos):
        """Create cycle for testing - tail points to node at position pos"""
        if not self.head or pos < 0:
            return
        
        # Find tail and node at position
        tail = self.head
        cycle_node = None
        current = self.head
        index = 0
        
        while current:
            if index == pos:
                cycle_node = current
            if not current.next:
                tail = current
                break
            current = current.next
            index += 1
        
        if cycle_node:
            tail.next = cycle_node
            print(f"✓ Created cycle: tail → node at position {pos} (value={cycle_node.data})")
    
    def has_cycle(self):
        """
        Floyd's Cycle Detection - THE TORTOISE AND HARE!
        Time: O(n), Space: O(1)
        """
        print("\n🐢🐇 Floyd's Algorithm: Tortoise and Hare")
        print("Tortoise moves 1 step, Hare moves 2 steps")
        print("If they meet, there's a cycle!")
        
        if not self.head:
            return False
        
        slow = self.head  # Tortoise 🐢
        fast = self.head  # Hare 🐇
        
        step = 0
        while fast and fast.next:
            slow = slow.next        # Move 1 step
            fast = fast.next.next   # Move 2 steps
            step += 1
            
            print(f"\nStep {step}:")
            print(f"  🐢 Tortoise at: {slow.data}")
            print(f"  🐇 Hare at: {fast.data if fast else 'None'}")
            
            if slow == fast:
                print(f"\n✅ CYCLE DETECTED! They met at node {slow.data}")
                return True
        
        print("\n✅ NO CYCLE - Hare reached the end")
        return False
    
    def find_cycle_start(self):
        """
        Find where the cycle starts
        Time: O(n), Space: O(1)
        """
        print("\n🔍 Finding cycle start...")
        
        if not self.head:
            return None
        
        # Step 1: Detect cycle and find meeting point
        slow = self.head
        fast = self.head
        
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            
            if slow == fast:
                print(f"✓ Cycle detected, meeting point: {slow.data}")
                break
        else:
            print("✗ No cycle found")
            return None
        
        # Step 2: Find cycle start
        # Move one pointer to head, keep other at meeting point
        # Move both at same speed - they'll meet at cycle start!
        print("\n🎯 Finding cycle start:")
        print("  Moving one pointer to HEAD")
        print("  Moving both at same speed...")
        
        slow = self.head
        step = 0
        
        while slow != fast:
            slow = slow.next
            fast = fast.next
            step += 1
            print(f"  Step {step}: slow={slow.data}, fast={fast.data}")
        
        print(f"\n✅ Cycle starts at: {slow.data}")
        return slow
    
    def get_cycle_length(self):
        """
        Get length of the cycle
        Time: O(n), Space: O(1)
        """
        if not self.head:
            return 0
        
        # Detect cycle
        slow = self.head
        fast = self.head
        
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            
            if slow == fast:
                # Found cycle, now count length
                length = 1
                current = slow.next
                
                while current != slow:
                    length += 1
                    current = current.next
                
                print(f"✓ Cycle length: {length} nodes")
                return length
        
        return 0
    
    def remove_cycle(self):
        """
        Remove cycle from linked list
        Time: O(n), Space: O(1)
        """
        print("\n🔧 Removing cycle...")
        
        if not self.head:
            return
        
        # Find cycle start
        slow = self.head
        fast = self.head
        
        # Detect cycle
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            
            if slow == fast:
                break
        else:
            print("✗ No cycle to remove")
            return
        
        # Find cycle start
        slow = self.head
        while slow != fast:
            slow = slow.next
            fast = fast.next
        
        cycle_start = slow
        print(f"✓ Cycle starts at: {cycle_start.data}")
        
        # Find node before cycle start (in the cycle)
        while fast.next != cycle_start:
            fast = fast.next
        
        # Break the cycle
        print(f"✓ Breaking link: {fast.data}.next = null")
        fast.next = None
        print("✅ Cycle removed!")
    
    def print_list(self, max_nodes=20):
        """Print list (with limit to avoid infinite loop if cycle exists)"""
        if not self.head:
            print("List: (empty)")
            return
        
        current = self.head
        elements = []
        count = 0
        
        while current and count < max_nodes:
            elements.append(str(current.data))
            current = current.next
            count += 1
        
        if count == max_nodes and current:
            elements.append("... (cycle or long list)")
        
        print(f"List: {' → '.join(elements)}")

# Example 1: Detect Cycle
print("=" * 70)
print("Example 1: Floyd's Cycle Detection Algorithm")
print("=" * 70)

ll = LinkedList()
for val in [1, 2, 3, 4, 5, 6]:
    ll.insert_at_tail(val)

print("\nList without cycle:")
ll.print_list()
ll.has_cycle()

print("\n" + "─" * 70)
print("Creating cycle: tail → node at position 2 (value=3)")
print("─" * 70)

ll.create_cycle(2)  # Create cycle: 6 → 3

print("\nList with cycle:")
print("1 → 2 → 3 → 4 → 5 → 6")
print("        ↑           ↓")
print("        └───────────┘")

ll.has_cycle()

# Example 2: Find Cycle Start
print("\n" + "=" * 70)
print("Example 2: Find Where Cycle Starts")
print("=" * 70)

ll2 = LinkedList()
for val in [10, 20, 30, 40, 50]:
    ll2.insert_at_tail(val)

ll2.create_cycle(1)  # Cycle at position 1 (value=20)

print("\nList structure:")
print("10 → 20 → 30 → 40 → 50")
print("     ↑                ↓")
print("     └────────────────┘")

ll2.find_cycle_start()

# Example 3: Cycle Length
print("\n" + "=" * 70)
print("Example 3: Get Cycle Length")
print("=" * 70)

ll3 = LinkedList()
for val in [1, 2, 3, 4, 5]:
    ll3.insert_at_tail(val)

ll3.create_cycle(2)  # Cycle: 5 → 3

print("\nList structure:")
print("1 → 2 → 3 → 4 → 5")
print("        ↑       ↓")
print("        └───────┘")

ll3.get_cycle_length()

# Example 4: Remove Cycle
print("\n" + "=" * 70)
print("Example 4: Remove Cycle")
print("=" * 70)

ll4 = LinkedList()
for val in [100, 200, 300, 400]:
    ll4.insert_at_tail(val)

ll4.create_cycle(1)

print("\nBefore removing cycle:")
print("Has cycle:", ll4.has_cycle())

ll4.remove_cycle()

print("\nAfter removing cycle:")
ll4.print_list()
print("Has cycle:", ll4.has_cycle())

# Visual Explanation
print("\n" + "=" * 70)
print("How Floyd's Algorithm Works")
print("=" * 70)

print("\nWHY IT WORKS:")
print("─" * 70)
print("If there's a cycle:")
print("  • Slow pointer (🐢) moves 1 step at a time")
print("  • Fast pointer (🐇) moves 2 steps at a time")
print("  • Fast will eventually 'lap' slow inside the cycle")
print("  • They MUST meet if cycle exists!")

print("\nIf there's NO cycle:")
print("  • Fast pointer reaches end (null)")
print("  • They never meet")

print("\n" + "=" * 70)
print("Finding Cycle Start - The Math")
print("=" * 70)

print("\nGiven:")
print("  • Distance from head to cycle start = x")
print("  • Distance from cycle start to meeting point = y")
print("  • Cycle length = C")

print("\nWhen they meet:")
print("  • Slow traveled: x + y")
print("  • Fast traveled: x + y + nC (n = number of cycles)")
print("  • Fast = 2 × Slow")
print("  • Therefore: x + y + nC = 2(x + y)")
print("  • Simplify: x = nC - y")

print("\nSo if we:")
print("  1. Move one pointer to head")
print("  2. Move both at same speed")
print("  3. They meet at cycle start!")

# Complexity Analysis
print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)
print(f"{'Operation':<30} {'Time':<15} {'Space':<15}")
print("-" * 70)
print(f"{'Detect cycle':<30} {'O(n)':<15} {'O(1) ✓':<15}")
print(f"{'Find cycle start':<30} {'O(n)':<15} {'O(1) ✓':<15}")
print(f"{'Get cycle length':<30} {'O(n)':<15} {'O(1) ✓':<15}")
print(f"{'Remove cycle':<30} {'O(n)':<15} {'O(1) ✓':<15}")

print("\nAlternative: Using HashSet")
print(f"{'Detect with HashSet':<30} {'O(n)':<15} {'O(n)':<15}")
print("✗ Not optimal - uses extra space!")

# Interview Tips
print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)
print("✅ Floyd's algorithm is THE standard solution")
print("✅ Always mention O(1) space - key advantage!")
print("✅ Draw the cycle to visualize")
print("✅ Explain tortoise and hare analogy")
print("✅ Handle edge cases: empty list, no cycle, single node")

print("\n" + "=" * 70)
print("Common Interview Variations")
print("=" * 70)
print("1. Detect if cycle exists ✓ (covered)")
print("2. Find cycle start ✓ (covered)")
print("3. Find cycle length ✓ (covered)")
print("4. Remove cycle ✓ (covered)")
print("5. Find intersection of two lists (similar technique!)")

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)
print("✓ Floyd's algorithm: slow (1 step) + fast (2 steps)")
print("✓ If cycle exists, they WILL meet")
print("✓ O(n) time, O(1) space - optimal!")
print("✓ Can find start, length, and remove cycle")
print("✓ Top interview question at FAANG companies!")
