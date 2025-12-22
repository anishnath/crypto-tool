"""
Stack & Queue Combined Problems
Advanced problems combining both data structures
Essential for FAANG interviews!
"""

from collections import deque

# ============================================================================
# PROBLEM 1: Queue using Two Stacks
# ============================================================================

class QueueUsingStacks:
    """
    Implement queue using two stacks
    Time: O(1) amortized for enqueue/dequeue
    """
    
    def __init__(self):
        self.stack1 = []  # For enqueue
        self.stack2 = []  # For dequeue
    
    def enqueue(self, item):
        """Add to queue - O(1)"""
        self.stack1.append(item)
        print(f"➕ Enqueued {item}")
    
    def dequeue(self):
        """Remove from queue - O(1) amortized"""
        if not self.stack2:
            # Transfer from stack1 to stack2
            while self.stack1:
                self.stack2.append(self.stack1.pop())
        
        if not self.stack2:
            print("✗ Queue empty!")
            return None
        
        item = self.stack2.pop()
        print(f"➖ Dequeued {item}")
        return item
    
    def peek(self):
        """View front - O(1) amortized"""
        if not self.stack2:
            while self.stack1:
                self.stack2.append(self.stack1.pop())
        return self.stack2[-1] if self.stack2 else None

# ============================================================================
# PROBLEM 2: Stack using Two Queues
# ============================================================================

class StackUsingQueues:
    """
    Implement stack using two queues
    Time: O(n) for push, O(1) for pop
    """
    
    def __init__(self):
        self.q1 = deque()
        self.q2 = deque()
    
    def push(self, item):
        """Add to stack - O(n)"""
        # Add to q2
        self.q2.append(item)
        
        # Move all from q1 to q2
        while self.q1:
            self.q2.append(self.q1.popleft())
        
        # Swap q1 and q2
        self.q1, self.q2 = self.q2, self.q1
        print(f"➕ Pushed {item}")
    
    def pop(self):
        """Remove from stack - O(1)"""
        if not self.q1:
            print("✗ Stack empty!")
            return None
        
        item = self.q1.popleft()
        print(f"➖ Popped {item}")
        return item
    
    def peek(self):
        """View top - O(1)"""
        return self.q1[0] if self.q1 else None

# ============================================================================
# PROBLEM 3: Next Greater Element
# ============================================================================

def next_greater_element(arr):
    """
    Find next greater element for each element
    Time: O(n), Space: O(n)
    Uses monotonic stack!
    """
    print(f"\n🔍 Next Greater Element: {arr}")
    
    result = [-1] * len(arr)
    stack = []  # Stores indices
    
    for i in range(len(arr)):
        # Pop smaller elements
        while stack and arr[stack[-1]] < arr[i]:
            idx = stack.pop()
            result[idx] = arr[i]
            print(f"  For {arr[idx]} at index {idx} → Next greater is {arr[i]}")
        
        stack.append(i)
    
    # Remaining elements have no greater element
    for idx in stack:
        print(f"  For {arr[idx]} at index {idx} → No greater element")
    
    print(f"  ✅ Result: {result}")
    return result

# ============================================================================
# PROBLEM 4: Min Stack (O(1) getMin)
# ============================================================================

class MinStack:
    """
    Stack with O(1) getMin operation
    Tracks minimum at each level
    """
    
    def __init__(self):
        self.stack = []
        self.min_stack = []
    
    def push(self, item):
        """Push - O(1)"""
        self.stack.append(item)
        
        # Update min stack
        if not self.min_stack or item <= self.min_stack[-1]:
            self.min_stack.append(item)
        
        print(f"➕ Pushed {item}, Current min: {self.get_min()}")
    
    def pop(self):
        """Pop - O(1)"""
        if not self.stack:
            return None
        
        item = self.stack.pop()
        
        # Update min stack
        if item == self.min_stack[-1]:
            self.min_stack.pop()
        
        print(f"➖ Popped {item}, Current min: {self.get_min()}")
        return item
    
    def get_min(self):
        """Get minimum - O(1)"""
        return self.min_stack[-1] if self.min_stack else None
    
    def peek(self):
        """View top - O(1)"""
        return self.stack[-1] if self.stack else None

# ============================================================================
# PROBLEM 5: Sliding Window Maximum (Deque)
# ============================================================================

def sliding_window_maximum(arr, k):
    """
    Find maximum in each window of size k
    Time: O(n), Space: O(k)
    Uses monotonic deque!
    """
    print(f"\n🔍 Sliding Window Maximum: array={arr}, k={k}")
    
    dq = deque()  # Stores indices
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
            window = arr[i-k+1:i+1]
            print(f"  Window {window} → Max: {arr[dq[0]]}")
    
    print(f"  ✅ Result: {result}")
    return result

# ============================================================================
# PROBLEM 6: Valid Parentheses (Stack)
# ============================================================================

def is_valid_parentheses(s):
    """
    Check if parentheses are valid
    Time: O(n), Space: O(n)
    """
    print(f"\n🔍 Valid Parentheses: '{s}'")
    
    stack = []
    matching = {'(': ')', '[': ']', '{': '}'}
    
    for char in s:
        if char in matching:
            stack.append(char)
        elif char in matching.values():
            if not stack or matching[stack.pop()] != char:
                print(f"  ✗ Invalid!")
                return False
    
    is_valid = len(stack) == 0
    print(f"  ✅ Valid!" if is_valid else "  ✗ Invalid (unclosed)!")
    return is_valid

# ============================================================================
# EXAMPLE 1: Queue using Stacks
# ============================================================================

print("=" * 70)
print("Problem 1: Queue using Two Stacks")
print("=" * 70)

q = QueueUsingStacks()

print("\nEnqueuing 1, 2, 3:")
q.enqueue(1)
q.enqueue(2)
q.enqueue(3)

print("\nDequeuing (should get 1, then 2):")
q.dequeue()
q.dequeue()

print("\nEnqueuing 4, 5:")
q.enqueue(4)
q.enqueue(5)

print("\nDequeuing remaining:")
q.dequeue()
q.dequeue()
q.dequeue()

print("\n" + "─" * 70)
print("KEY INSIGHT:")
print("  • Stack1 for enqueue (O(1))")
print("  • Stack2 for dequeue (O(1) amortized)")
print("  • Transfer only when stack2 is empty")
print("─" * 70)

# ============================================================================
# EXAMPLE 2: Stack using Queues
# ============================================================================

print("\n" + "=" * 70)
print("Problem 2: Stack using Two Queues")
print("=" * 70)

s = StackUsingQueues()

print("\nPushing 1, 2, 3:")
s.push(1)
s.push(2)
s.push(3)

print("\nPopping (should get 3, then 2):")
s.pop()
s.pop()

print("\n" + "─" * 70)
print("KEY INSIGHT:")
print("  • Push: O(n) - move all elements to maintain LIFO")
print("  • Pop: O(1) - just dequeue from front")
print("─" * 70)

# ============================================================================
# EXAMPLE 3: Next Greater Element
# ============================================================================

print("\n" + "=" * 70)
print("Problem 3: Next Greater Element")
print("=" * 70)

test_cases = [
    [4, 5, 2, 25],
    [13, 7, 6, 12],
    [1, 2, 3, 4, 5],
]

for arr in test_cases:
    next_greater_element(arr)

print("\n" + "─" * 70)
print("ALGORITHM: Monotonic Stack")
print("  1. Iterate through array")
print("  2. Pop smaller elements from stack")
print("  3. Current element is next greater for popped elements")
print("  4. Push current index to stack")
print("  Time: O(n) - each element pushed/popped once")
print("─" * 70)

# ============================================================================
# EXAMPLE 4: Min Stack
# ============================================================================

print("\n" + "=" * 70)
print("Problem 4: Min Stack (O(1) getMin)")
print("=" * 70)

min_stack = MinStack()

print("\nPushing 5, 3, 7, 1, 9:")
for val in [5, 3, 7, 1, 9]:
    min_stack.push(val)

print("\nPopping 3 times:")
for _ in range(3):
    min_stack.pop()

print("\n" + "─" * 70)
print("KEY INSIGHT:")
print("  • Main stack: stores all elements")
print("  • Min stack: stores minimums")
print("  • Push: update min stack if new min")
print("  • Pop: remove from min stack if it's the min")
print("  • All operations: O(1)")
print("─" * 70)

# ============================================================================
# EXAMPLE 5: Sliding Window Maximum
# ============================================================================

print("\n" + "=" * 70)
print("Problem 5: Sliding Window Maximum")
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
# EXAMPLE 6: Valid Parentheses
# ============================================================================

print("\n" + "=" * 70)
print("Problem 6: Valid Parentheses")
print("=" * 70)

test_cases = [
    "()",
    "()[]{}",
    "(]",
    "([)]",
    "{[()]}",
]

for s in test_cases:
    is_valid_parentheses(s)

# ============================================================================
# COMPLEXITY SUMMARY
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Summary")
print("=" * 70)

print(f"\n{'Problem':<30} {'Time':<20} {'Space':<15}")
print("─" * 70)
print(f"{'Queue using Stacks':<30} {'O(1) amortized':<20} {'O(n)':<15}")
print(f"{'Stack using Queues':<30} {'O(n) push, O(1) pop':<20} {'O(n)':<15}")
print(f"{'Next Greater Element':<30} {'O(n)':<20} {'O(n)':<15}")
print(f"{'Min Stack':<30} {'O(1) all ops':<20} {'O(n)':<15}")
print(f"{'Sliding Window Max':<30} {'O(n)':<20} {'O(k)':<15}")
print(f"{'Valid Parentheses':<30} {'O(n)':<20} {'O(n)':<15}")

# ============================================================================
# INTERVIEW TIPS
# ============================================================================

print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)

print("\n✅ Queue using Stacks:")
print("  • Two stacks: one for enqueue, one for dequeue")
print("  • Transfer only when dequeue stack is empty")
print("  • Amortized O(1) for both operations")

print("\n✅ Stack using Queues:")
print("  • Make push expensive (O(n))")
print("  • Keep pop cheap (O(1))")
print("  • Alternative: make pop expensive")

print("\n✅ Next Greater Element:")
print("  • Monotonic stack pattern!")
print("  • Very common in interviews")
print("  • O(n) time - each element touched twice")

print("\n✅ Min Stack:")
print("  • Auxiliary stack for minimums")
print("  • All operations O(1)")
print("  • Common follow-up: max stack")

print("\n✅ Sliding Window Maximum:")
print("  • Monotonic deque pattern!")
print("  • Maintain decreasing order")
print("  • O(n) time, O(k) space")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Combining data structures solves complex problems")
print("✓ Queue using Stacks: amortized O(1)")
print("✓ Stack using Queues: make one operation expensive")
print("✓ Monotonic stack: Next Greater Element pattern")
print("✓ Auxiliary stack: Min Stack pattern")
print("✓ Monotonic deque: Sliding Window Maximum")
print("✓ These are VERY common in FAANG interviews!")
