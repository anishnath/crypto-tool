"""
Tree Traversals
Different ways to visit all nodes in a tree
"""

# ============================================================================
# TREE NODE
# ============================================================================

class TreeNode:
    """Binary Tree Node"""
    
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None

# ============================================================================
# DEPTH-FIRST TRAVERSALS (DFS)
# ============================================================================

def inorder_traversal(root):
    """
    Inorder: Left → Root → Right
    For BST: gives sorted order!
    Time: O(n), Space: O(h)
    """
    result = []
    
    def inorder_helper(node):
        if not node:
            return
        
        inorder_helper(node.left)      # Visit left subtree
        result.append(node.data)        # Visit root
        inorder_helper(node.right)      # Visit right subtree
    
    inorder_helper(root)
    return result

def preorder_traversal(root):
    """
    Preorder: Root → Left → Right
    Use: Copy tree, create prefix expression
    Time: O(n), Space: O(h)
    """
    result = []
    
    def preorder_helper(node):
        if not node:
            return
        
        result.append(node.data)        # Visit root
        preorder_helper(node.left)      # Visit left subtree
        preorder_helper(node.right)     # Visit right subtree
    
    preorder_helper(root)
    return result

def postorder_traversal(root):
    """
    Postorder: Left → Right → Root
    Use: Delete tree, evaluate postfix expression
    Time: O(n), Space: O(h)
    """
    result = []
    
    def postorder_helper(node):
        if not node:
            return
        
        postorder_helper(node.left)     # Visit left subtree
        postorder_helper(node.right)    # Visit right subtree
        result.append(node.data)        # Visit root
    
    postorder_helper(root)
    return result

# ============================================================================
# BREADTH-FIRST TRAVERSAL (BFS)
# ============================================================================

def level_order_traversal(root):
    """
    Level-order: Visit nodes level by level
    Use: Find shortest path, serialize tree
    Time: O(n), Space: O(w) where w = max width
    """
    if not root:
        return []
    
    result = []
    queue = [root]
    
    while queue:
        node = queue.pop(0)
        result.append(node.data)
        
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)
    
    return result

# ============================================================================
# ITERATIVE TRAVERSALS (Using Stack)
# ============================================================================

def inorder_iterative(root):
    """
    Iterative inorder using stack
    Time: O(n), Space: O(h)
    """
    result = []
    stack = []
    current = root
    
    while current or stack:
        # Go to leftmost node
        while current:
            stack.append(current)
            current = current.left
        
        # Process node
        current = stack.pop()
        result.append(current.data)
        
        # Go to right subtree
        current = current.right
    
    return result

def preorder_iterative(root):
    """
    Iterative preorder using stack
    Time: O(n), Space: O(h)
    """
    if not root:
        return []
    
    result = []
    stack = [root]
    
    while stack:
        node = stack.pop()
        result.append(node.data)
        
        # Push right first (so left is processed first)
        if node.right:
            stack.append(node.right)
        if node.left:
            stack.append(node.left)
    
    return result

def postorder_iterative(root):
    """
    Iterative postorder using two stacks
    Time: O(n), Space: O(h)
    """
    if not root:
        return []
    
    result = []
    stack1 = [root]
    stack2 = []
    
    while stack1:
        node = stack1.pop()
        stack2.append(node)
        
        if node.left:
            stack1.append(node.left)
        if node.right:
            stack1.append(node.right)
    
    while stack2:
        result.append(stack2.pop().data)
    
    return result

# ============================================================================
# HELPER: BUILD SAMPLE TREE
# ============================================================================

def build_sample_tree():
    """
    Build tree:
           1
          / \
         2   3
        / \   \
       4   5   6
    """
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(3)
    root.left.left = TreeNode(4)
    root.left.right = TreeNode(5)
    root.right.right = TreeNode(6)
    
    return root

# ============================================================================
# EXAMPLE 1: All DFS Traversals
# ============================================================================

print("=" * 70)
print("Example 1: Depth-First Traversals (DFS)")
print("=" * 70)

root = build_sample_tree()

print("\nTree Structure:")
print("       1")
print("      / \\")
print("     2   3")
print("    / \\   \\")
print("   4   5   6")

print("\n🔄 Inorder (Left-Root-Right):")
result = inorder_traversal(root)
print(f"   Result: {result}")
print("   Use: Get sorted order from BST")

print("\n🔄 Preorder (Root-Left-Right):")
result = preorder_traversal(root)
print(f"   Result: {result}")
print("   Use: Copy tree, create prefix expression")

print("\n🔄 Postorder (Left-Right-Root):")
result = postorder_traversal(root)
print(f"   Result: {result}")
print("   Use: Delete tree, evaluate postfix expression")

# ============================================================================
# EXAMPLE 2: Breadth-First Traversal (BFS)
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Breadth-First Traversal (BFS)")
print("=" * 70)

print("\n🔄 Level-order (level by level):")
result = level_order_traversal(root)
print(f"   Result: {result}")
print("   Use: Find shortest path, serialize tree")

# ============================================================================
# EXAMPLE 3: Iterative vs Recursive
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Iterative Traversals (Using Stack)")
print("=" * 70)

print("\n📚 Inorder (Iterative):")
recursive = inorder_traversal(root)
iterative = inorder_iterative(root)
print(f"   Recursive: {recursive}")
print(f"   Iterative: {iterative}")
print(f"   Match: {recursive == iterative} ✓")

print("\n📚 Preorder (Iterative):")
recursive = preorder_traversal(root)
iterative = preorder_iterative(root)
print(f"   Recursive: {recursive}")
print(f"   Iterative: {iterative}")
print(f"   Match: {recursive == iterative} ✓")

print("\n📚 Postorder (Iterative):")
recursive = postorder_traversal(root)
iterative = postorder_iterative(root)
print(f"   Recursive: {recursive}")
print(f"   Iterative: {iterative}")
print(f"   Match: {recursive == iterative} ✓")

# ============================================================================
# EXAMPLE 4: When to Use Each Traversal
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: When to Use Each Traversal")
print("=" * 70)

print("\n✓ Inorder (Left-Root-Right):")
print("  • Get sorted order from BST")
print("  • Validate BST")
print("  • Find kth smallest element")

print("\n✓ Preorder (Root-Left-Right):")
print("  • Copy/clone tree")
print("  • Serialize tree")
print("  • Create prefix expression")

print("\n✓ Postorder (Left-Right-Root):")
print("  • Delete tree (delete children first)")
print("  • Evaluate postfix expression")
print("  • Calculate tree size/height")

print("\n✓ Level-order (BFS):")
print("  • Find shortest path")
print("  • Level-by-level processing")
print("  • Print tree by levels")

# ============================================================================
# COMPLEXITY SUMMARY
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Summary")
print("=" * 70)

print(f"\n{'Traversal':<25} {'Time':<20} {'Space':<20}")
print("─" * 65)
print(f"{'Inorder (recursive)':<25} {'O(n)':<20} {'O(h)':<20}")
print(f"{'Preorder (recursive)':<25} {'O(n)':<20} {'O(h)':<20}")
print(f"{'Postorder (recursive)':<25} {'O(n)':<20} {'O(h)':<20}")
print(f"{'Level-order (BFS)':<25} {'O(n)':<20} {'O(w)':<20}")
print(f"{'Inorder (iterative)':<25} {'O(n)':<20} {'O(h)':<20}")
print(f"{'Preorder (iterative)':<25} {'O(n)':<20} {'O(h)':<20}")
print(f"{'Postorder (iterative)':<25} {'O(n)':<20} {'O(h)':<20}")

print("\nWhere:")
print("  n = number of nodes")
print("  h = height of tree (O(log n) balanced, O(n) skewed)")
print("  w = maximum width of tree")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ DFS (Depth-First): Go deep before wide")
print("  • Inorder: Left-Root-Right (sorted for BST)")
print("  • Preorder: Root-Left-Right (copy tree)")
print("  • Postorder: Left-Right-Root (delete tree)")

print("\n✓ BFS (Breadth-First): Go wide before deep")
print("  • Level-order: Visit level by level")
print("  • Uses queue instead of recursion")

print("\n✓ Recursive vs Iterative:")
print("  • Recursive: Cleaner code, uses call stack")
print("  • Iterative: Explicit stack, more control")

print("\n✓ All traversals visit every node exactly once: O(n)")
