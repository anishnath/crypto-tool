"""
Binary Tree Basics
Understanding hierarchical data structures
"""

# ============================================================================
# BINARY TREE NODE
# ============================================================================

class TreeNode:
    """
    Binary Tree Node
    Each node has at most 2 children: left and right
    """
    
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None

# ============================================================================
# BINARY TREE IMPLEMENTATION
# ============================================================================

class BinaryTree:
    """
    Binary Tree - Hierarchical structure
    Each node has at most 2 children
    """
    
    def __init__(self):
        self.root = None
    
    def insert_level_order(self, data):
        """
        Insert in level-order (breadth-first)
        Ensures complete binary tree
        Time: O(n), Space: O(n)
        """
        new_node = TreeNode(data)
        
        if not self.root:
            self.root = new_node
            print(f"➕ Inserted {data} as root")
            return
        
        # Use queue for level-order insertion
        queue = [self.root]
        
        while queue:
            node = queue.pop(0)
            
            # Insert at first available position
            if not node.left:
                node.left = new_node
                print(f"➕ Inserted {data} as left child of {node.data}")
                return
            else:
                queue.append(node.left)
            
            if not node.right:
                node.right = new_node
                print(f"➕ Inserted {data} as right child of {node.data}")
                return
            else:
                queue.append(node.right)
    
    def search(self, data):
        """
        Search for a value in the tree
        Time: O(n), Space: O(h) where h = height
        """
        print(f"\n🔍 Searching for {data}...")
        return self._search_recursive(self.root, data)
    
    def _search_recursive(self, node, data):
        """Recursive search helper"""
        if not node:
            return False
        
        if node.data == data:
            print(f"  ✅ Found {data}!")
            return True
        
        # Search in both subtrees
        return (self._search_recursive(node.left, data) or 
                self._search_recursive(node.right, data))
    
    def height(self):
        """
        Calculate height of tree
        Height = longest path from root to leaf
        Time: O(n), Space: O(h)
        """
        h = self._height_recursive(self.root)
        print(f"\n📏 Tree height: {h}")
        return h
    
    def _height_recursive(self, node):
        """Recursive height calculation"""
        if not node:
            return -1  # Height of empty tree is -1
        
        left_height = self._height_recursive(node.left)
        right_height = self._height_recursive(node.right)
        
        return 1 + max(left_height, right_height)
    
    def size(self):
        """
        Count total nodes in tree
        Time: O(n), Space: O(h)
        """
        count = self._size_recursive(self.root)
        print(f"\n📊 Tree size: {count} nodes")
        return count
    
    def _size_recursive(self, node):
        """Recursive size calculation"""
        if not node:
            return 0
        
        return 1 + self._size_recursive(node.left) + self._size_recursive(node.right)
    
    def level_order_traversal(self):
        """
        Level-order (breadth-first) traversal
        Visit nodes level by level
        Time: O(n), Space: O(w) where w = max width
        """
        if not self.root:
            print("Tree is empty")
            return []
        
        result = []
        queue = [self.root]
        
        print("\n🔄 Level-order traversal:")
        
        while queue:
            node = queue.pop(0)
            result.append(node.data)
            print(f"  Visited: {node.data}")
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        return result
    
    def display(self):
        """Display tree structure"""
        print("\n🌳 Tree Structure:")
        self._display_helper(self.root, "", True)
    
    def _display_helper(self, node, prefix, is_tail):
        """Helper for tree display"""
        if node:
            print(prefix + ("└── " if is_tail else "├── ") + str(node.data))
            
            if node.left or node.right:
                if node.left:
                    self._display_helper(node.left, 
                                       prefix + ("    " if is_tail else "│   "), 
                                       False if node.right else True)
                if node.right:
                    self._display_helper(node.right, 
                                       prefix + ("    " if is_tail else "│   "), 
                                       True)

# ============================================================================
# TREE TYPES
# ============================================================================

def check_tree_type(tree):
    """
    Check what type of binary tree it is
    """
    print("\n📋 Tree Type Analysis:")
    
    # Full Binary Tree: Every node has 0 or 2 children
    is_full = is_full_binary_tree(tree.root)
    print(f"  Full Binary Tree: {is_full}")
    
    # Complete Binary Tree: All levels filled except possibly last
    is_complete = is_complete_binary_tree(tree.root)
    print(f"  Complete Binary Tree: {is_complete}")
    
    # Perfect Binary Tree: All internal nodes have 2 children, all leaves at same level
    is_perfect = is_perfect_binary_tree(tree.root)
    print(f"  Perfect Binary Tree: {is_perfect}")

def is_full_binary_tree(node):
    """Every node has 0 or 2 children"""
    if not node:
        return True
    
    # Leaf node
    if not node.left and not node.right:
        return True
    
    # Both children exist
    if node.left and node.right:
        return (is_full_binary_tree(node.left) and 
                is_full_binary_tree(node.right))
    
    # One child exists
    return False

def is_complete_binary_tree(root):
    """All levels filled except possibly last"""
    if not root:
        return True
    
    queue = [root]
    flag = False  # Flag when we see a non-full node
    
    while queue:
        node = queue.pop(0)
        
        if node.left:
            if flag:
                return False
            queue.append(node.left)
        else:
            flag = True
        
        if node.right:
            if flag:
                return False
            queue.append(node.right)
        else:
            flag = True
    
    return True

def is_perfect_binary_tree(root):
    """All internal nodes have 2 children, all leaves at same level"""
    depth = tree_depth(root)
    return is_perfect_helper(root, depth, 0)

def tree_depth(node):
    """Calculate depth"""
    d = 0
    while node:
        d += 1
        node = node.left
    return d

def is_perfect_helper(node, depth, level):
    """Helper for perfect tree check"""
    if not node:
        return True
    
    # Leaf node
    if not node.left and not node.right:
        return depth == level + 1
    
    # One child
    if not node.left or not node.right:
        return False
    
    # Both children
    return (is_perfect_helper(node.left, depth, level + 1) and
            is_perfect_helper(node.right, depth, level + 1))

# ============================================================================
# EXAMPLE 1: Basic Binary Tree
# ============================================================================

print("=" * 70)
print("Example 1: Creating a Binary Tree")
print("=" * 70)

tree = BinaryTree()

# Insert nodes
print("\nInserting nodes:")
for value in [1, 2, 3, 4, 5, 6, 7]:
    tree.insert_level_order(value)

# Display tree
tree.display()

# Tree properties
tree.height()
tree.size()

# ============================================================================
# EXAMPLE 2: Search Operation
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Searching in Tree")
print("=" * 70)

tree.search(5)
tree.search(10)

# ============================================================================
# EXAMPLE 3: Level-order Traversal
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Level-order Traversal")
print("=" * 70)

result = tree.level_order_traversal()
print(f"\nTraversal result: {result}")

# ============================================================================
# EXAMPLE 4: Tree Types
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Tree Type Analysis")
print("=" * 70)

check_tree_type(tree)

# ============================================================================
# COMPLEXITY SUMMARY
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Summary")
print("=" * 70)

print(f"\n{'Operation':<25} {'Time':<20} {'Space':<20}")
print("─" * 65)
print(f"{'Insert (level-order)':<25} {'O(n)':<20} {'O(n)':<20}")
print(f"{'Search':<25} {'O(n)':<20} {'O(h)':<20}")
print(f"{'Height':<25} {'O(n)':<20} {'O(h)':<20}")
print(f"{'Size':<25} {'O(n)':<20} {'O(h)':<20}")
print(f"{'Level-order traversal':<25} {'O(n)':<20} {'O(w)':<20}")

print("\nWhere:")
print("  n = number of nodes")
print("  h = height of tree")
print("  w = maximum width of tree")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Binary Tree: Each node has at most 2 children")
print("✓ Height: Longest path from root to leaf")
print("✓ Complete Tree: All levels filled except possibly last")
print("✓ Perfect Tree: All leaves at same level")
print("✓ Level-order: Visit nodes level by level (BFS)")
print("✓ Trees are naturally recursive structures!")
