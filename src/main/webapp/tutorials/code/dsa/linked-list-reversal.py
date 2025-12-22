"""
Linked List Reversal - Iterative and Recursive
One of the most common interview problems!
Master the 3-pointer technique
"""

class Node:
    """Node in a singly linked list"""
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    """Singly Linked List with reversal operations"""
    def __init__(self):
        self.head = None
    
    def insert_at_tail(self, data):
        """Insert at end for building list"""
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node
    
    def print_list(self, label="List"):
        """Print list"""
        if not self.head:
            print(f"{label}: (empty)")
            return
        
        current = self.head
        elements = []
        while current:
            elements.append(str(current.data))
            current = current.next
        
        print(f"{label}: {' → '.join(elements)} → None")
    
    def reverse_iterative(self):
        """
        Reverse list iteratively - THE CLASSIC 3-POINTER TECHNIQUE
        Time: O(n), Space: O(1)
        """
        print("\n🔄 Reversing list iteratively (3-pointer technique)...")
        
        # The 3 pointers
        prev = None      # Previous node
        current = self.head  # Current node
        
        step = 1
        while current:
            print(f"\nStep {step}:")
            print(f"  prev = {prev.data if prev else 'None'}")
            print(f"  current = {current.data}")
            print(f"  current.next = {current.next.data if current.next else 'None'}")
            
            # CRITICAL: Save next before changing pointer!
            next_node = current.next
            print(f"  → Saved next_node = {next_node.data if next_node else 'None'}")
            
            # Reverse the pointer
            current.next = prev
            print(f"  → Reversed: current.next now points to {prev.data if prev else 'None'}")
            
            # Move pointers forward
            prev = current
            current = next_node
            print(f"  → Moved forward: prev={prev.data}, current={current.data if current else 'None'}")
            
            step += 1
        
        # Update head
        self.head = prev
        print(f"\n✅ New head: {self.head.data}")
    
    def reverse_recursive(self):
        """
        Reverse list recursively
        Time: O(n), Space: O(n) due to call stack
        """
        print("\n🔄 Reversing list recursively...")
        
        def reverse_helper(node, depth=0):
            indent = "  " * depth
            print(f"{indent}reverse_helper({node.data if node else 'None'})")
            
            # Base case: empty or single node
            if not node or not node.next:
                print(f"{indent}→ Base case reached! Returning {node.data if node else 'None'}")
                return node
            
            # Recursive case
            print(f"{indent}→ Recursing on next node ({node.next.data})...")
            new_head = reverse_helper(node.next, depth + 1)
            
            # Reverse the pointer
            print(f"{indent}→ Back from recursion. Reversing pointers:")
            print(f"{indent}  {node.next.data}.next = {node.data}")
            node.next.next = node
            node.next = None
            
            return new_head
        
        self.head = reverse_helper(self.head)
        print(f"\n✅ New head: {self.head.data}")
    
    def reverse_first_k(self, k):
        """
        Reverse first k nodes
        Time: O(k), Space: O(1)
        """
        print(f"\n🔄 Reversing first {k} nodes...")
        
        if not self.head or k <= 1:
            return
        
        prev = None
        current = self.head
        count = 0
        
        # Reverse first k nodes
        while current and count < k:
            next_node = current.next
            current.next = prev
            prev = current
            current = next_node
            count += 1
            print(f"  Step {count}: Reversed node {prev.data}")
        
        # Connect with remaining list
        if self.head:
            self.head.next = current
        
        # Update head
        self.head = prev
        print(f"✅ Reversed first {k} nodes")

# Example 1: Iterative Reversal (Most Common!)
print("=" * 70)
print("Example 1: Iterative Reversal - The 3-Pointer Technique")
print("=" * 70)

ll = LinkedList()
for val in [1, 2, 3, 4, 5]:
    ll.insert_at_tail(val)

print("\nOriginal list:")
ll.print_list()

print("\n" + "─" * 70)
print("THE 3-POINTER TECHNIQUE:")
print("─" * 70)
print("We use 3 pointers: prev, current, next")
print("1. Save next (so we don't lose it)")
print("2. Reverse current's pointer to prev")
print("3. Move prev and current forward")
print("─" * 70)

ll.reverse_iterative()

print("\nReversed list:")
ll.print_list()

# Example 2: Recursive Reversal
print("\n" + "=" * 70)
print("Example 2: Recursive Reversal")
print("=" * 70)

ll2 = LinkedList()
for val in [10, 20, 30, 40]:
    ll2.insert_at_tail(val)

print("\nOriginal list:")
ll2.print_list()

ll2.reverse_recursive()

print("\nReversed list:")
ll2.print_list()

# Example 3: Reverse First K Nodes
print("\n" + "=" * 70)
print("Example 3: Reverse First K Nodes")
print("=" * 70)

ll3 = LinkedList()
for val in [1, 2, 3, 4, 5, 6, 7]:
    ll3.insert_at_tail(val)

print("\nOriginal list:")
ll3.print_list()

k = 3
ll3.reverse_first_k(k)

print(f"\nAfter reversing first {k} nodes:")
ll3.print_list()

# Example 4: Visual Comparison
print("\n" + "=" * 70)
print("Example 4: Visual Comparison")
print("=" * 70)

print("\nBEFORE REVERSAL:")
print("HEAD → [1] → [2] → [3] → [4] → None")
print("       ↓     ↓     ↓     ↓")
print("     prev  curr  next")

print("\nSTEP 1: Reverse [1]'s pointer")
print("None ← [1]   [2] → [3] → [4] → None")
print("       ↑     ↓")
print("     prev  curr")

print("\nSTEP 2: Reverse [2]'s pointer")
print("None ← [1] ← [2]   [3] → [4] → None")
print("             ↑     ↓")
print("           prev  curr")

print("\nSTEP 3: Reverse [3]'s pointer")
print("None ← [1] ← [2] ← [3]   [4] → None")
print("                   ↑     ↓")
print("                 prev  curr")

print("\nSTEP 4: Reverse [4]'s pointer")
print("None ← [1] ← [2] ← [3] ← [4]   None")
print("                         ↑     ↓")
print("                       prev  curr")

print("\nFINAL: Update HEAD")
print("HEAD → [4] → [3] → [2] → [1] → None")
print("       ✓ Reversed!")

# Complexity Analysis
print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)
print(f"{'Method':<25} {'Time':<15} {'Space':<15} {'Notes':<30}")
print("-" * 70)
print(f"{'Iterative (3-pointer)':<25} {'O(n)':<15} {'O(1) ✓':<15} {'Most efficient!':<30}")
print(f"{'Recursive':<25} {'O(n)':<15} {'O(n)':<15} {'Call stack overhead':<30}")
print(f"{'Reverse first k':<25} {'O(k)':<15} {'O(1) ✓':<15} {'Partial reversal':<30}")

# Interview Tips
print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)
print("✅ ALWAYS use iterative 3-pointer for interviews (O(1) space!)")
print("✅ Draw it out on paper - visualize pointer changes")
print("✅ Remember to save 'next' BEFORE reversing pointer")
print("✅ Common mistake: Losing reference to rest of list")
print("✅ Edge cases: Empty list, single node, two nodes")

print("\n" + "=" * 70)
print("Common Interview Variations")
print("=" * 70)
print("1. Reverse entire list ✓ (covered above)")
print("2. Reverse first k nodes ✓ (covered above)")
print("3. Reverse in groups of k (e.g., reverse every 3 nodes)")
print("4. Reverse between positions m and n")
print("5. Check if list is palindrome (reverse half, compare)")

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)
print("✓ 3-pointer technique: prev, current, next")
print("✓ Save next BEFORE reversing pointer!")
print("✓ Iterative is better than recursive (O(1) space)")
print("✓ One of the most common interview problems")
print("✓ Master this - it appears in 50%+ of linked list interviews!")
