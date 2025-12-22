"""
Linked List Two Pointer Techniques
Master patterns: Find middle, Nth from end, Palindrome check
Essential interview patterns!
"""

class Node:
    """Node in a singly linked list"""
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    """Linked List with two-pointer techniques"""
    def __init__(self):
        self.head = None
    
    def insert_at_tail(self, data):
        """Insert at end"""
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node
    
    def print_list(self):
        """Print list"""
        if not self.head:
            print("List: (empty)")
            return
        
        current = self.head
        elements = []
        while current:
            elements.append(str(current.data))
            current = current.next
        
        print(f"List: {' → '.join(elements)}")
    
    def find_middle(self):
        """
        Find middle node using SLOW-FAST POINTERS
        Time: O(n), Space: O(1)
        """
        print("\n🎯 Finding middle using slow-fast pointers...")
        
        if not self.head:
            return None
        
        slow = self.head  # Moves 1 step
        fast = self.head  # Moves 2 steps
        
        step = 0
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            step += 1
            print(f"  Step {step}: slow={slow.data}, fast={fast.data if fast else 'None'}")
        
        print(f"\n✅ Middle node: {slow.data}")
        print(f"   When fast reaches end, slow is at middle!")
        return slow
    
    def find_nth_from_end(self, n):
        """
        Find nth node from end using TWO POINTERS WITH GAP
        Time: O(n), Space: O(1)
        """
        print(f"\n🎯 Finding {n}th node from end...")
        
        if not self.head:
            return None
        
        # Step 1: Move first pointer n steps ahead
        first = self.head
        for i in range(n):
            if not first:
                print(f"✗ List has fewer than {n} nodes")
                return None
            first = first.next
            print(f"  Moving first pointer: step {i+1}")
        
        # Step 2: Move both pointers until first reaches end
        second = self.head
        step = 0
        
        print(f"\n  Now moving both pointers together...")
        while first:
            first = first.next
            second = second.next
            step += 1
            print(f"  Step {step}: first={first.data if first else 'None'}, second={second.data}")
        
        print(f"\n✅ {n}th node from end: {second.data}")
        print(f"   Gap of {n} maintained throughout!")
        return second
    
    def is_palindrome(self):
        """
        Check if list is palindrome using SLOW-FAST + REVERSE
        Time: O(n), Space: O(1)
        """
        print("\n🎯 Checking if list is palindrome...")
        
        if not self.head or not self.head.next:
            print("✅ Single node or empty - palindrome!")
            return True
        
        # Step 1: Find middle using slow-fast
        print("\nStep 1: Finding middle...")
        slow = fast = self.head
        
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
        
        print(f"  Middle found at: {slow.data}")
        
        # Step 2: Reverse second half
        print("\nStep 2: Reversing second half...")
        prev = None
        current = slow
        
        while current:
            next_node = current.next
            current.next = prev
            prev = current
            current = next_node
        
        second_half = prev
        print(f"  Second half reversed, starts at: {second_half.data}")
        
        # Step 3: Compare both halves
        print("\nStep 3: Comparing both halves...")
        first_half = self.head
        
        while second_half:
            print(f"  Comparing: {first_half.data} vs {second_half.data}")
            if first_half.data != second_half.data:
                print("\n✗ Not a palindrome!")
                return False
            first_half = first_half.next
            second_half = second_half.next
        
        print("\n✅ It's a palindrome!")
        return True
    
    def remove_nth_from_end(self, n):
        """
        Remove nth node from end
        Time: O(n), Space: O(1)
        """
        print(f"\n🔧 Removing {n}th node from end...")
        
        # Dummy node to handle edge cases
        dummy = Node(0)
        dummy.next = self.head
        
        # Move first pointer n+1 steps ahead
        first = dummy
        for i in range(n + 1):
            if not first:
                print(f"✗ List has fewer than {n} nodes")
                return
            first = first.next
        
        # Move both until first reaches end
        second = dummy
        while first:
            first = first.next
            second = second.next
        
        # Remove the node
        removed_value = second.next.data if second.next else None
        second.next = second.next.next if second.next else None
        
        self.head = dummy.next
        print(f"✅ Removed node with value: {removed_value}")
    
    def get_intersection(self, other_list):
        """
        Find intersection point of two lists
        Time: O(m + n), Space: O(1)
        """
        print("\n🎯 Finding intersection of two lists...")
        
        if not self.head or not other_list.head:
            return None
        
        # Get lengths
        len1 = self.get_length()
        len2 = other_list.get_length()
        
        print(f"  List 1 length: {len1}")
        print(f"  List 2 length: {len2}")
        
        # Align starting points
        ptr1 = self.head
        ptr2 = other_list.head
        
        if len1 > len2:
            for _ in range(len1 - len2):
                ptr1 = ptr1.next
        else:
            for _ in range(len2 - len1):
                ptr2 = ptr2.next
        
        # Find intersection
        while ptr1 and ptr2:
            if ptr1 == ptr2:
                print(f"✅ Intersection at node: {ptr1.data}")
                return ptr1
            ptr1 = ptr1.next
            ptr2 = ptr2.next
        
        print("✗ No intersection")
        return None
    
    def get_length(self):
        """Get length of list"""
        count = 0
        current = self.head
        while current:
            count += 1
            current = current.next
        return count

# Example 1: Find Middle
print("=" * 70)
print("Example 1: Find Middle Node - Slow-Fast Pointers")
print("=" * 70)

ll = LinkedList()
for val in [1, 2, 3, 4, 5]:
    ll.insert_at_tail(val)

print("\nOriginal list:")
ll.print_list()

print("\n" + "─" * 70)
print("TECHNIQUE: Slow moves 1 step, Fast moves 2 steps")
print("When fast reaches end, slow is at middle!")
print("─" * 70)

middle = ll.find_middle()

print("\nVisual:")
print("1 → 2 → 3 → 4 → 5")
print("        ↑")
print("      Middle")

# Example 2: Nth from End
print("\n" + "=" * 70)
print("Example 2: Find Nth Node from End - Two Pointers with Gap")
print("=" * 70)

ll2 = LinkedList()
for val in [10, 20, 30, 40, 50, 60]:
    ll2.insert_at_tail(val)

print("\nOriginal list:")
ll2.print_list()

n = 2
print(f"\n" + "─" * 70)
print(f"TECHNIQUE: Move first pointer {n} steps ahead")
print(f"Then move both - when first reaches end, second is at {n}th from end!")
print("─" * 70)

nth_node = ll2.find_nth_from_end(n)

print("\nVisual:")
print("10 → 20 → 30 → 40 → 50 → 60")
print("                      ↑")
print("                 2nd from end")

# Example 3: Palindrome Check
print("\n" + "=" * 70)
print("Example 3: Check Palindrome - Slow-Fast + Reverse")
print("=" * 70)

# Palindrome list
ll3 = LinkedList()
for val in [1, 2, 3, 2, 1]:
    ll3.insert_at_tail(val)

print("\nList 1 (palindrome):")
ll3.print_list()
ll3.is_palindrome()

# Non-palindrome list
ll4 = LinkedList()
for val in [1, 2, 3, 4, 5]:
    ll4.insert_at_tail(val)

print("\n" + "─" * 70)
print("\nList 2 (not palindrome):")
ll4.print_list()
ll4.is_palindrome()

print("\n" + "─" * 70)
print("TECHNIQUE:")
print("1. Find middle using slow-fast")
print("2. Reverse second half")
print("3. Compare both halves")
print("─" * 70)

# Example 4: Remove Nth from End
print("\n" + "=" * 70)
print("Example 4: Remove Nth Node from End")
print("=" * 70)

ll5 = LinkedList()
for val in [1, 2, 3, 4, 5]:
    ll5.insert_at_tail(val)

print("\nOriginal list:")
ll5.print_list()

n = 2
ll5.remove_nth_from_end(n)

print(f"\nAfter removing {n}nd from end:")
ll5.print_list()

# Pattern Summary
print("\n" + "=" * 70)
print("Two Pointer Patterns Summary")
print("=" * 70)

print("\n1. SLOW-FAST PATTERN (different speeds)")
print("   Use for: Find middle, Detect cycle, Palindrome")
print("   • Slow: 1 step")
print("   • Fast: 2 steps")
print("   • When fast reaches end, slow is at middle")

print("\n2. TWO POINTERS WITH GAP (same speed, different start)")
print("   Use for: Nth from end, Remove nth from end")
print("   • Move first pointer n steps ahead")
print("   • Move both together")
print("   • When first reaches end, second is at target")

print("\n3. TWO POINTERS FROM DIFFERENT LISTS")
print("   Use for: Find intersection, Merge lists")
print("   • Align starting points")
print("   • Move both at same speed")
print("   • Find meeting point")

# Complexity Analysis
print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)
print(f"{'Operation':<30} {'Time':<15} {'Space':<15}")
print("-" * 70)
print(f"{'Find middle':<30} {'O(n)':<15} {'O(1) ✓':<15}")
print(f"{'Find nth from end':<30} {'O(n)':<15} {'O(1) ✓':<15}")
print(f"{'Check palindrome':<30} {'O(n)':<15} {'O(1) ✓':<15}")
print(f"{'Remove nth from end':<30} {'O(n)':<15} {'O(1) ✓':<15}")
print(f"{'Find intersection':<30} {'O(m+n)':<15} {'O(1) ✓':<15}")

print("\nAlternative: Using Length")
print(f"{'Find middle (with length)':<30} {'O(n)':<15} {'O(1)':<15}")
print("✗ Requires two passes - less elegant!")

# Interview Tips
print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)
print("✅ Two pointers are THE standard for linked list problems")
print("✅ Always mention O(1) space - key advantage!")
print("✅ Draw the pointers moving to visualize")
print("✅ Know when to use slow-fast vs gap pattern")
print("✅ Handle edge cases: empty, single node, even/odd length")

print("\n" + "=" * 70)
print("Common Interview Questions")
print("=" * 70)
print("1. Find middle node ✓ (covered)")
print("2. Find nth from end ✓ (covered)")
print("3. Check palindrome ✓ (covered)")
print("4. Remove nth from end ✓ (covered)")
print("5. Find intersection ✓ (covered)")
print("6. Reorder list (L0→Ln→L1→Ln-1...)")
print("7. Partition list around value")

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)
print("✓ Slow-fast: Different speeds (1 step vs 2 steps)")
print("✓ Gap pattern: Same speed, different start positions")
print("✓ All operations in O(n) time, O(1) space")
print("✓ Master these patterns - they appear EVERYWHERE!")
print("✓ Two pointers > calculating length (more elegant!)")
