"""
Stack Basics - LIFO (Last In, First Out)
Two implementations: Array-based and Linked List-based
Essential data structure for function calls, undo/redo, expression evaluation!
"""

# ============================================================================
# IMPLEMENTATION 1: Stack with Array (Dynamic)
# ============================================================================

class StackArray:
    """Stack implementation using dynamic array (Python list)"""
    
    def __init__(self, capacity=10):
        self.items = []
        self.capacity = capacity
    
    def push(self, item):
        """
        Push item onto stack - O(1) amortized
        """
        if len(self.items) >= self.capacity:
            print(f"⚠️  Stack at capacity ({self.capacity}), auto-resizing...")
            self.capacity *= 2
        
        self.items.append(item)
        print(f"➕ Pushed {item} onto stack")
    
    def pop(self):
        """
        Pop item from stack - O(1)
        """
        if self.is_empty():
            print("✗ Cannot pop - stack is empty!")
            return None
        
        item = self.items.pop()
        print(f"➖ Popped {item} from stack")
        return item
    
    def peek(self):
        """
        View top item without removing - O(1)
        """
        if self.is_empty():
            print("✗ Cannot peek - stack is empty!")
            return None
        
        return self.items[-1]
    
    def is_empty(self):
        """Check if stack is empty - O(1)"""
        return len(self.items) == 0
    
    def size(self):
        """Get stack size - O(1)"""
        return len(self.items)
    
    def display(self):
        """Display stack contents"""
        if self.is_empty():
            print("Stack: (empty)")
            return
        
        print("\nStack (top to bottom):")
        for i in range(len(self.items) - 1, -1, -1):
            if i == len(self.items) - 1:
                print(f"  TOP  → [{self.items[i]}]")
            else:
                print(f"         [{self.items[i]}]")
        print()

# ============================================================================
# IMPLEMENTATION 2: Stack with Linked List
# ============================================================================

class Node:
    """Node for linked list-based stack"""
    def __init__(self, data):
        self.data = data
        self.next = None

class StackLinkedList:
    """Stack implementation using linked list"""
    
    def __init__(self):
        self.top = None
        self._size = 0
    
    def push(self, item):
        """
        Push item onto stack - O(1)
        Always add at head (top of stack)
        """
        new_node = Node(item)
        new_node.next = self.top
        self.top = new_node
        self._size += 1
        print(f"➕ Pushed {item} onto stack")
    
    def pop(self):
        """
        Pop item from stack - O(1)
        Remove from head (top of stack)
        """
        if self.is_empty():
            print("✗ Cannot pop - stack is empty!")
            return None
        
        item = self.top.data
        self.top = self.top.next
        self._size -= 1
        print(f"➖ Popped {item} from stack")
        return item
    
    def peek(self):
        """
        View top item without removing - O(1)
        """
        if self.is_empty():
            print("✗ Cannot peek - stack is empty!")
            return None
        
        return self.top.data
    
    def is_empty(self):
        """Check if stack is empty - O(1)"""
        return self.top is None
    
    def size(self):
        """Get stack size - O(1)"""
        return self._size
    
    def display(self):
        """Display stack contents"""
        if self.is_empty():
            print("Stack: (empty)")
            return
        
        print("\nStack (top to bottom):")
        current = self.top
        first = True
        while current:
            if first:
                print(f"  TOP  → [{current.data}]")
                first = False
            else:
                print(f"         [{current.data}]")
            current = current.next
        print()

# ============================================================================
# EXAMPLE 1: Array-based Stack
# ============================================================================

print("=" * 70)
print("Example 1: Stack with Array")
print("=" * 70)

stack_arr = StackArray(capacity=5)

print("\nPushing elements:")
for val in [10, 20, 30, 40, 50]:
    stack_arr.push(val)
    stack_arr.display()

print("─" * 70)
print(f"Peek (top element): {stack_arr.peek()}")
print(f"Stack size: {stack_arr.size()}")

print("\n" + "─" * 70)
print("Popping elements:")
for _ in range(3):
    stack_arr.pop()
    stack_arr.display()

print("─" * 70)
print(f"Peek after pops: {stack_arr.peek()}")
print(f"Stack size: {stack_arr.size()}")

# ============================================================================
# EXAMPLE 2: Linked List-based Stack
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Stack with Linked List")
print("=" * 70)

stack_ll = StackLinkedList()

print("\nPushing elements:")
for val in ['A', 'B', 'C', 'D', 'E']:
    stack_ll.push(val)
    stack_ll.display()

print("─" * 70)
print(f"Peek (top element): {stack_ll.peek()}")
print(f"Stack size: {stack_ll.size()}")

print("\n" + "─" * 70)
print("Popping elements:")
for _ in range(3):
    stack_ll.pop()
    stack_ll.display()

# ============================================================================
# EXAMPLE 3: LIFO Demonstration
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: LIFO (Last In, First Out) Demonstration")
print("=" * 70)

stack = StackArray()

print("\nScenario: Function Call Stack")
print("Simulating nested function calls:\n")

functions = ["main()", "processData()", "validateInput()", "checkFormat()"]

print("Calling functions (push onto stack):")
for func in functions:
    stack.push(func)
    print(f"  → Entered {func}")

stack.display()

print("Returning from functions (pop from stack):")
while not stack.is_empty():
    func = stack.pop()
    print(f"  ← Exited {func}")

print("\nNotice: Last function called is first to return!")
print("This is LIFO in action!")

# ============================================================================
# EXAMPLE 4: Edge Cases
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Edge Cases")
print("=" * 70)

edge_stack = StackArray()

print("\n1. Pop from empty stack:")
edge_stack.pop()

print("\n2. Peek at empty stack:")
result = edge_stack.peek()
print(f"   Result: {result}")

print("\n3. Check if empty:")
print(f"   Is empty? {edge_stack.is_empty()}")

print("\n4. Push one element:")
edge_stack.push(100)
print(f"   Is empty? {edge_stack.is_empty()}")
print(f"   Size: {edge_stack.size()}")

print("\n5. Pop last element:")
edge_stack.pop()
print(f"   Is empty? {edge_stack.is_empty()}")

# ============================================================================
# COMPARISON: Array vs Linked List
# ============================================================================

print("\n" + "=" * 70)
print("Array vs Linked List Implementation Comparison")
print("=" * 70)

print(f"\n{'Operation':<20} {'Array':<20} {'Linked List':<20} {'Winner':<15}")
print("─" * 70)
print(f"{'Push':<20} {'O(1) amortized':<20} {'O(1)':<20} {'Linked List':<15}")
print(f"{'Pop':<20} {'O(1)':<20} {'O(1)':<20} {'Tie':<15}")
print(f"{'Peek':<20} {'O(1)':<20} {'O(1)':<20} {'Tie':<15}")
print(f"{'Is Empty':<20} {'O(1)':<20} {'O(1)':<20} {'Tie':<15}")
print(f"{'Size':<20} {'O(1)':<20} {'O(1)':<20} {'Tie':<15}")
print(f"{'Memory overhead':<20} {'Less (contiguous)':<20} {'More (pointers)':<20} {'Array':<15}")
print(f"{'Cache performance':<20} {'Better':<20} {'Worse':<20} {'Array':<15}")
print(f"{'Dynamic resizing':<20} {'Needed':<20} {'Not needed':<20} {'Linked List':<15}")

# ============================================================================
# WHEN TO USE EACH
# ============================================================================

print("\n" + "=" * 70)
print("When to Use Each Implementation")
print("=" * 70)

print("\n✅ USE ARRAY-BASED STACK WHEN:")
print("  • Size is predictable")
print("  • Memory efficiency is important")
print("  • Cache performance matters")
print("  • Simple implementation preferred")

print("\n✅ USE LINKED LIST-BASED STACK WHEN:")
print("  • Size is unpredictable")
print("  • No resizing overhead acceptable")
print("  • Memory fragmentation not a concern")
print("  • Already using linked structures")

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Operation':<20} {'Time Complexity':<25} {'Space Complexity':<20}")
print("─" * 70)
print(f"{'Push':<20} {'O(1) amortized':<25} {'O(1)':<20}")
print(f"{'Pop':<20} {'O(1)':<25} {'O(1)':<20}")
print(f"{'Peek':<20} {'O(1)':<25} {'O(1)':<20}")
print(f"{'Is Empty':<20} {'O(1)':<25} {'O(1)':<20}")
print(f"{'Size':<20} {'O(1)':<25} {'O(1)':<20}")

print("\nNote: All operations are O(1) - constant time!")
print("This makes stack extremely efficient!")

# ============================================================================
# REAL-WORLD APPLICATIONS
# ============================================================================

print("\n" + "=" * 70)
print("Real-World Applications of Stacks")
print("=" * 70)

print("\n1. Function Call Stack")
print("   • Every function call pushes onto stack")
print("   • Return pops from stack")
print("   • Enables recursion!")

print("\n2. Undo/Redo Functionality")
print("   • Text editors (Ctrl+Z)")
print("   • Photoshop layers")
print("   • Browser back button")

print("\n3. Expression Evaluation")
print("   • Infix to postfix conversion")
print("   • Calculator implementation")
print("   • Compiler syntax checking")

print("\n4. Backtracking Algorithms")
print("   • Maze solving")
print("   • Sudoku solver")
print("   • Tree/graph traversal (DFS)")

print("\n5. Browser History")
print("   • Back button navigation")
print("   • Forward button (with second stack)")

# ============================================================================
# INTERVIEW TIPS
# ============================================================================

print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)

print("\n✅ Always mention LIFO principle!")
print("✅ Know both array and linked list implementations")
print("✅ All operations are O(1) - emphasize this!")
print("✅ Discuss trade-offs: array vs linked list")
print("✅ Common follow-up: Implement Min Stack (O(1) getMin)")
print("✅ Know applications: function calls, undo/redo, expression eval")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Stack is LIFO - Last In, First Out")
print("✓ All operations are O(1) - super efficient!")
print("✓ Two implementations: array and linked list")
print("✓ Array: better cache, needs resizing")
print("✓ Linked list: no resizing, more memory overhead")
print("✓ Used everywhere: function calls, undo/redo, expression eval")
print("✓ Foundation for many algorithms!")
