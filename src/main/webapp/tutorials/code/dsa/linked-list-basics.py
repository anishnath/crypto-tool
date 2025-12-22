"""
Singly Linked List - Basics
Foundation for all linked list problems
Time complexities for each operation included
"""

class Node:
    """Node in a singly linked list"""
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    """Singly Linked List implementation"""
    def __init__(self):
        self.head = None
    
    def is_empty(self):
        """Check if list is empty - O(1)"""
        return self.head is None
    
    def insert_at_head(self, data):
        """Insert at beginning - O(1)"""
        print(f"Inserting {data} at head")
        new_node = Node(data)
        new_node.next = self.head
        self.head = new_node
        print(f"✓ Inserted {data} at head")
    
    def insert_at_tail(self, data):
        """Insert at end - O(n)"""
        print(f"Inserting {data} at tail")
        new_node = Node(data)
        
        if self.is_empty():
            self.head = new_node
            print(f"✓ List was empty, {data} is now head")
            return
        
        # Traverse to end
        current = self.head
        steps = 0
        while current.next:
            current = current.next
            steps += 1
        
        current.next = new_node
        print(f"✓ Inserted {data} at tail (traversed {steps} nodes)")
    
    def insert_at_position(self, data, position):
        """Insert at specific position - O(n)"""
        print(f"Inserting {data} at position {position}")
        
        if position == 0:
            self.insert_at_head(data)
            return
        
        new_node = Node(data)
        current = self.head
        
        # Traverse to position-1
        for i in range(position - 1):
            if current is None:
                print(f"✗ Position {position} out of bounds")
                return
            current = current.next
        
        if current is None:
            print(f"✗ Position {position} out of bounds")
            return
        
        new_node.next = current.next
        current.next = new_node
        print(f"✓ Inserted {data} at position {position}")
    
    def delete_head(self):
        """Delete first node - O(1)"""
        if self.is_empty():
            print("✗ Cannot delete from empty list")
            return None
        
        data = self.head.data
        self.head = self.head.next
        print(f"✓ Deleted head: {data}")
        return data
    
    def delete_tail(self):
        """Delete last node - O(n)"""
        if self.is_empty():
            print("✗ Cannot delete from empty list")
            return None
        
        if self.head.next is None:
            data = self.head.data
            self.head = None
            print(f"✓ Deleted only node: {data}")
            return data
        
        # Traverse to second-last node
        current = self.head
        while current.next.next:
            current = current.next
        
        data = current.next.data
        current.next = None
        print(f"✓ Deleted tail: {data}")
        return data
    
    def delete_value(self, value):
        """Delete first occurrence of value - O(n)"""
        print(f"Deleting value: {value}")
        
        if self.is_empty():
            print("✗ List is empty")
            return False
        
        # If head contains value
        if self.head.data == value:
            self.head = self.head.next
            print(f"✓ Deleted {value} from head")
            return True
        
        # Search for value
        current = self.head
        while current.next:
            if current.next.data == value:
                current.next = current.next.next
                print(f"✓ Deleted {value}")
                return True
            current = current.next
        
        print(f"✗ Value {value} not found")
        return False
    
    def search(self, value):
        """Search for value - O(n)"""
        print(f"Searching for: {value}")
        current = self.head
        position = 0
        
        while current:
            if current.data == value:
                print(f"✓ Found {value} at position {position}")
                return position
            current = current.next
            position += 1
        
        print(f"✗ Value {value} not found")
        return -1
    
    def get_length(self):
        """Get list length - O(n)"""
        count = 0
        current = self.head
        while current:
            count += 1
            current = current.next
        return count
    
    def print_list(self):
        """Print list - O(n)"""
        if self.is_empty():
            print("List: (empty)")
            return
        
        current = self.head
        elements = []
        while current:
            elements.append(str(current.data))
            current = current.next
        
        print(f"List: {' -> '.join(elements)} -> None")
    
    def reverse(self):
        """Reverse the list - O(n)"""
        print("Reversing list...")
        prev = None
        current = self.head
        
        while current:
            next_node = current.next
            current.next = prev
            prev = current
            current = next_node
        
        self.head = prev
        print("✓ List reversed")

# Example 1: Basic Operations
print("=" * 70)
print("Example 1: Basic Linked List Operations")
print("=" * 70)

ll = LinkedList()
print("\n1. Insert at head:")
ll.insert_at_head(3)
ll.insert_at_head(2)
ll.insert_at_head(1)
ll.print_list()

print("\n2. Insert at tail:")
ll.insert_at_tail(4)
ll.insert_at_tail(5)
ll.print_list()

print("\n3. Insert at position:")
ll.insert_at_position(2.5, 2)
ll.print_list()

print(f"\n4. List length: {ll.get_length()}")

# Example 2: Search Operations
print("\n" + "=" * 70)
print("Example 2: Search Operations")
print("=" * 70)
ll.print_list()
ll.search(3)
ll.search(10)

# Example 3: Delete Operations
print("\n" + "=" * 70)
print("Example 3: Delete Operations")
print("=" * 70)
ll.print_list()

print("\n1. Delete head:")
ll.delete_head()
ll.print_list()

print("\n2. Delete tail:")
ll.delete_tail()
ll.print_list()

print("\n3. Delete specific value:")
ll.delete_value(3)
ll.print_list()

# Example 4: Reverse
print("\n" + "=" * 70)
print("Example 4: Reverse List")
print("=" * 70)
ll.print_list()
ll.reverse()
ll.print_list()

# Example 5: Build from scratch
print("\n" + "=" * 70)
print("Example 5: Build List from Array")
print("=" * 70)

def build_list_from_array(arr):
    """Build linked list from array"""
    ll = LinkedList()
    for val in arr:
        ll.insert_at_tail(val)
    return ll

arr = [10, 20, 30, 40, 50]
print(f"Array: {arr}")
ll2 = build_list_from_array(arr)
ll2.print_list()

# Complexity Summary
print("\n" + "=" * 70)
print("Time Complexity Summary")
print("=" * 70)
print(f"{'Operation':<25} {'Time':<15} {'Why':<30}")
print("-" * 70)
print(f"{'Insert at head':<25} {'O(1)':<15} {'Direct pointer update':<30}")
print(f"{'Insert at tail':<25} {'O(n)':<15} {'Must traverse to end':<30}")
print(f"{'Insert at position':<25} {'O(n)':<15} {'Must traverse to position':<30}")
print(f"{'Delete head':<25} {'O(1)':<15} {'Direct pointer update':<30}")
print(f"{'Delete tail':<25} {'O(n)':<15} {'Must find second-last':<30}")
print(f"{'Delete value':<25} {'O(n)':<15} {'Must search for value':<30}")
print(f"{'Search':<25} {'O(n)':<15} {'Must traverse list':<30}")
print(f"{'Get length':<25} {'O(n)':<15} {'Must count all nodes':<30}")
print(f"{'Reverse':<25} {'O(n)':<15} {'Must visit all nodes':<30}")

# Linked List vs Array
print("\n" + "=" * 70)
print("Linked List vs Array")
print("=" * 70)
print(f"{'Operation':<25} {'Array':<15} {'Linked List':<15}")
print("-" * 70)
print(f"{'Access by index':<25} {'O(1) ✓':<15} {'O(n)':<15}")
print(f"{'Insert at head':<25} {'O(n)':<15} {'O(1) ✓':<15}")
print(f"{'Insert at tail':<25} {'O(1) ✓':<15} {'O(n) or O(1)*':<15}")
print(f"{'Delete at head':<25} {'O(n)':<15} {'O(1) ✓':<15}")
print(f"{'Search':<25} {'O(n)':<15} {'O(n)':<15}")
print(f"{'Memory':<25} {'Contiguous ✓':<15} {'Scattered':<15}")
print(f"{'Size':<25} {'Fixed':<15} {'Dynamic ✓':<15}")

print("\n* O(1) with tail pointer")

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)
print("✓ Linked List: Dynamic size, O(1) insert/delete at head")
print("✓ Array: O(1) random access, contiguous memory")
print("✓ Use Linked List when: Frequent insert/delete at beginning")
print("✓ Use Array when: Need random access, memory locality")
print("\n✓ Master linked lists - foundation for stacks, queues, graphs!")
