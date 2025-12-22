"""
Binary Search Tree (BST)
Ordered tree structure for efficient search
"""

# ============================================================================
# BST NODE
# ============================================================================

class TreeNode:
    """BST Node"""
    
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None

# ============================================================================
# BINARY SEARCH TREE
# ============================================================================

class BinarySearchTree:
    """
    Binary Search Tree
    Property: left < root < right for every node
    """
    
    def __init__(self):
        self.root = None
    
    def insert(self, data):
        """
        Insert value into BST
        Maintains BST property
        Time: O(log n) average, O(n) worst
        """
        print(f"\n➕ Inserting {data}")
        self.root = self._insert_recursive(self.root, data)
    
    def _insert_recursive(self, node, data):
        """Recursive insert helper"""
        if not node:
            print(f"   Created new node with {data}")
            return TreeNode(data)
        
        if data < node.data:
            print(f"   {data} < {node.data}, go left")
            node.left = self._insert_recursive(node.left, data)
        elif data > node.data:
            print(f"   {data} > {node.data}, go right")
            node.right = self._insert_recursive(node.right, data)
        else:
            print(f"   {data} already exists, skipping")
        
        return node
    
    def search(self, data):
        """
        Search for value in BST
        Time: O(log n) average, O(n) worst
        """
        print(f"\n🔍 Searching for {data}")
        return self._search_recursive(self.root, data)
    
    def _search_recursive(self, node, data):
        """Recursive search helper"""
        if not node:
            print(f"   Not found!")
            return False
        
        if data == node.data:
            print(f"   ✅ Found {data}!")
            return True
        elif data < node.data:
            print(f"   {data} < {node.data}, search left")
            return self._search_recursive(node.left, data)
        else:
            print(f"   {data} > {node.data}, search right")
            return self._search_recursive(node.right, data)
    
    def find_min(self):
        """
        Find minimum value (leftmost node)
        Time: O(h) where h = height
        """
        if not self.root:
            return None
        
        current = self.root
        while current.left:
            current = current.left
        
        print(f"\n📉 Minimum value: {current.data}")
        return current.data
    
    def find_max(self):
        """
        Find maximum value (rightmost node)
        Time: O(h) where h = height
        """
        if not self.root:
            return None
        
        current = self.root
        while current.right:
            current = current.right
        
        print(f"\n📈 Maximum value: {current.data}")
        return current.data
    
    def delete(self, data):
        """
        Delete value from BST
        Time: O(log n) average, O(n) worst
        """
        print(f"\n🗑️ Deleting {data}")
        self.root = self._delete_recursive(self.root, data)
    
    def _delete_recursive(self, node, data):
        """Recursive delete helper"""
        if not node:
            print(f"   Value not found")
            return None
        
        if data < node.data:
            node.left = self._delete_recursive(node.left, data)
        elif data > node.data:
            node.right = self._delete_recursive(node.right, data)
        else:
            # Found node to delete
            print(f"   Found {data}")
            
            # Case 1: Leaf node (no children)
            if not node.left and not node.right:
                print(f"   Leaf node - simply remove")
                return None
            
            # Case 2: One child
            if not node.left:
                print(f"   Has only right child - replace with right")
                return node.right
            if not node.right:
                print(f"   Has only left child - replace with left")
                return node.left
            
            # Case 3: Two children
            print(f"   Has two children - find successor")
            # Find inorder successor (min in right subtree)
            successor = self._find_min_node(node.right)
            print(f"   Successor is {successor.data}")
            
            # Replace with successor
            node.data = successor.data
            
            # Delete successor
            node.right = self._delete_recursive(node.right, successor.data)
        
        return node
    
    def _find_min_node(self, node):
        """Find minimum node in subtree"""
        current = node
        while current.left:
            current = current.left
        return current
    
    def is_valid_bst(self):
        """
        Check if tree is a valid BST
        Time: O(n)
        """
        result = self._is_valid_bst_helper(self.root, float('-inf'), float('inf'))
        print(f"\n✓ Is valid BST: {result}")
        return result
    
    def _is_valid_bst_helper(self, node, min_val, max_val):
        """Recursive BST validation"""
        if not node:
            return True
        
        # Check BST property
        if node.data <= min_val or node.data >= max_val:
            return False
        
        # Check left and right subtrees
        return (self._is_valid_bst_helper(node.left, min_val, node.data) and
                self._is_valid_bst_helper(node.right, node.data, max_val))
    
    def inorder(self):
        """
        Inorder traversal (gives sorted order!)
        Time: O(n)
        """
        result = []
        self._inorder_helper(self.root, result)
        return result
    
    def _inorder_helper(self, node, result):
        """Inorder helper"""
        if node:
            self._inorder_helper(node.left, result)
            result.append(node.data)
            self._inorder_helper(node.right, result)
    
    def display(self):
        """Display tree structure"""
        print("\n🌳 BST Structure:")
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
# EXAMPLE 1: Building a BST
# ============================================================================

print("=" * 70)
print("Example 1: Building a Binary Search Tree")
print("=" * 70)

bst = BinarySearchTree()

# Insert values
values = [50, 30, 70, 20, 40, 60, 80]
print(f"\nInserting values: {values}")

for val in values:
    bst.insert(val)

# Display tree
bst.display()

# ============================================================================
# EXAMPLE 2: Search Operations
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Searching in BST")
print("=" * 70)

bst.search(40)  # Found
bst.search(90)  # Not found

# ============================================================================
# EXAMPLE 3: Min and Max
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Finding Min and Max")
print("=" * 70)

bst.find_min()
bst.find_max()

# ============================================================================
# EXAMPLE 4: Inorder Traversal (Sorted!)
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Inorder Traversal")
print("=" * 70)

sorted_values = bst.inorder()
print(f"\nInorder traversal: {sorted_values}")
print("Notice: Values are in sorted order! ✓")

# ============================================================================
# EXAMPLE 5: BST Validation
# ============================================================================

print("\n" + "=" * 70)
print("Example 5: Validating BST")
print("=" * 70)

bst.is_valid_bst()

# ============================================================================
# EXAMPLE 6: Delete Operations
# ============================================================================

print("\n" + "=" * 70)
print("Example 6: Deleting Nodes")
print("=" * 70)

print("\n--- Delete leaf node (20) ---")
bst.delete(20)
bst.display()

print("\n--- Delete node with one child (30) ---")
bst.delete(30)
bst.display()

print("\n--- Delete node with two children (50) ---")
bst.delete(50)
bst.display()

print("\nFinal inorder:", bst.inorder())

# ============================================================================
# COMPLEXITY SUMMARY
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Summary")
print("=" * 70)

print(f"\n{'Operation':<25} {'Average Case':<20} {'Worst Case':<20}")
print("─" * 65)
print(f"{'Search':<25} {'O(log n)':<20} {'O(n)':<20}")
print(f"{'Insert':<25} {'O(log n)':<20} {'O(n)':<20}")
print(f"{'Delete':<25} {'O(log n)':<20} {'O(n)':<20}")
print(f"{'Find Min/Max':<25} {'O(log n)':<20} {'O(n)':<20}")
print(f"{'Inorder traversal':<25} {'O(n)':<20} {'O(n)':<20}")

print("\nWhere:")
print("  Average case: Balanced tree (height = log n)")
print("  Worst case: Skewed tree (height = n)")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ BST Property: left < root < right")
print("✓ Inorder traversal gives sorted order")
print("✓ O(log n) operations in balanced tree")
print("✓ O(n) worst case in skewed tree")
print("✓ Delete has 3 cases: leaf, one child, two children")
print("✓ Used in: databases, file systems, compilers")
