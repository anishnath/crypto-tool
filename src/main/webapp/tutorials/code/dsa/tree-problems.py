"""
Tree Problems & Patterns
Common tree problems with practical applications
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
# PATTERN 1: TREE DEPTH & HEIGHT
# ============================================================================

def max_depth(root):
    """
    Find maximum depth (height) of tree
    Real-world: File system depth, organization hierarchy levels
    Time: O(n), Space: O(h)
    """
    if not root:
        return 0
    
    left_depth = max_depth(root.left)
    right_depth = max_depth(root.right)
    
    return 1 + max(left_depth, right_depth)

def min_depth(root):
    """
    Find minimum depth to nearest leaf
    Real-world: Shortest path in decision tree
    Time: O(n), Space: O(h)
    """
    if not root:
        return 0
    
    # If one subtree is empty, go to the other
    if not root.left:
        return 1 + min_depth(root.right)
    if not root.right:
        return 1 + min_depth(root.left)
    
    return 1 + min(min_depth(root.left), min_depth(root.right))

# ============================================================================
# PATTERN 2: PATH PROBLEMS
# ============================================================================

def has_path_sum(root, target_sum):
    """
    Check if there's a root-to-leaf path with given sum
    Real-world: Budget allocation paths, cost analysis
    Time: O(n), Space: O(h)
    """
    if not root:
        return False
    
    # Leaf node
    if not root.left and not root.right:
        return root.data == target_sum
    
    # Check both subtrees with reduced sum
    remaining = target_sum - root.data
    return (has_path_sum(root.left, remaining) or 
            has_path_sum(root.right, remaining))

def find_all_paths(root, target_sum):
    """
    Find all root-to-leaf paths with given sum
    Real-world: Find all valid routes with cost constraint
    Time: O(n), Space: O(h)
    """
    result = []
    
    def dfs(node, current_sum, path):
        if not node:
            return
        
        path.append(node.data)
        current_sum += node.data
        
        # Leaf node
        if not node.left and not node.right:
            if current_sum == target_sum:
                result.append(path[:])  # Copy path
        else:
            dfs(node.left, current_sum, path)
            dfs(node.right, current_sum, path)
        
        path.pop()  # Backtrack
    
    dfs(root, 0, [])
    return result

# ============================================================================
# PATTERN 3: TREE DIAMETER
# ============================================================================

def diameter_of_tree(root):
    """
    Find diameter (longest path between any two nodes)
    Real-world: Network latency, communication distance
    Time: O(n), Space: O(h)
    """
    diameter = [0]  # Use list to modify in nested function
    
    def height(node):
        if not node:
            return 0
        
        left_height = height(node.left)
        right_height = height(node.right)
        
        # Update diameter (path through this node)
        diameter[0] = max(diameter[0], left_height + right_height)
        
        return 1 + max(left_height, right_height)
    
    height(root)
    return diameter[0]

# ============================================================================
# PATTERN 4: TREE SYMMETRY
# ============================================================================

def is_symmetric(root):
    """
    Check if tree is symmetric (mirror image)
    Real-world: Design validation, pattern matching
    Time: O(n), Space: O(h)
    """
    def is_mirror(left, right):
        if not left and not right:
            return True
        if not left or not right:
            return False
        
        return (left.data == right.data and
                is_mirror(left.left, right.right) and
                is_mirror(left.right, right.left))
    
    if not root:
        return True
    
    return is_mirror(root.left, root.right)

# ============================================================================
# PATTERN 5: INVERT TREE
# ============================================================================

def invert_tree(root):
    """
    Invert/mirror a binary tree
    Real-world: Image flipping, UI mirroring
    Time: O(n), Space: O(h)
    """
    if not root:
        return None
    
    # Swap children
    root.left, root.right = root.right, root.left
    
    # Recursively invert subtrees
    invert_tree(root.left)
    invert_tree(root.right)
    
    return root

# ============================================================================
# PATTERN 6: LOWEST COMMON ANCESTOR (BST)
# ============================================================================

def lca_bst(root, p, q):
    """
    Find Lowest Common Ancestor in BST
    Real-world: Find common manager, shared resource
    Time: O(h), Space: O(1)
    """
    while root:
        # Both in left subtree
        if p < root.data and q < root.data:
            root = root.left
        # Both in right subtree
        elif p > root.data and q > root.data:
            root = root.right
        else:
            # Split point is LCA
            return root.data
    
    return None

# ============================================================================
# PATTERN 7: KTH SMALLEST IN BST
# ============================================================================

def kth_smallest_bst(root, k):
    """
    Find kth smallest element in BST
    Real-world: Find median salary, nth percentile
    Time: O(n), Space: O(h)
    """
    count = [0]
    result = [None]
    
    def inorder(node):
        if not node or result[0] is not None:
            return
        
        inorder(node.left)
        
        count[0] += 1
        if count[0] == k:
            result[0] = node.data
            return
        
        inorder(node.right)
    
    inorder(root)
    return result[0]

# ============================================================================
# PATTERN 8: VALIDATE BST
# ============================================================================

def is_valid_bst(root):
    """
    Validate if tree is a valid BST
    Real-world: Data integrity check, validation
    Time: O(n), Space: O(h)
    """
    def validate(node, min_val, max_val):
        if not node:
            return True
        
        if node.data <= min_val or node.data >= max_val:
            return False
        
        return (validate(node.left, min_val, node.data) and
                validate(node.right, node.data, max_val))
    
    return validate(root, float('-inf'), float('inf'))

# ============================================================================
# PATTERN 9: LEVEL ORDER (ZIGZAG)
# ============================================================================

def zigzag_level_order(root):
    """
    Level order traversal in zigzag pattern
    Real-world: Printer scheduling, alternating priorities
    Time: O(n), Space: O(w)
    """
    if not root:
        return []
    
    result = []
    queue = [root]
    left_to_right = True
    
    while queue:
        level_size = len(queue)
        level = []
        
        for _ in range(level_size):
            node = queue.pop(0)
            level.append(node.data)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        if not left_to_right:
            level.reverse()
        
        result.append(level)
        left_to_right = not left_to_right
    
    return result

# ============================================================================
# PATTERN 10: SERIALIZE & DESERIALIZE
# ============================================================================

def serialize(root):
    """
    Serialize tree to string
    Real-world: Save tree to file, network transmission
    Time: O(n), Space: O(n)
    """
    if not root:
        return "null"
    
    return f"{root.data},{serialize(root.left)},{serialize(root.right)}"

def deserialize(data):
    """
    Deserialize string to tree
    Time: O(n), Space: O(n)
    """
    def build():
        val = next(values)
        if val == "null":
            return None
        
        node = TreeNode(int(val))
        node.left = build()
        node.right = build()
        return node
    
    values = iter(data.split(','))
    return build()

# ============================================================================
# HELPER: BUILD SAMPLE TREES
# ============================================================================

def build_sample_tree():
    """Build tree for testing"""
    root = TreeNode(10)
    root.left = TreeNode(5)
    root.right = TreeNode(15)
    root.left.left = TreeNode(3)
    root.left.right = TreeNode(7)
    root.right.right = TreeNode(18)
    return root

def build_symmetric_tree():
    """Build symmetric tree"""
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(2)
    root.left.left = TreeNode(3)
    root.left.right = TreeNode(4)
    root.right.left = TreeNode(4)
    root.right.right = TreeNode(3)
    return root

# ============================================================================
# EXAMPLES
# ============================================================================

print("=" * 70)
print("Tree Problems & Patterns")
print("=" * 70)

# Build sample tree
root = build_sample_tree()

print("\n📊 Pattern 1: Depth & Height")
print(f"Max depth: {max_depth(root)}")
print(f"Min depth: {min_depth(root)}")

print("\n🛤️ Pattern 2: Path Problems")
print(f"Has path sum 22? {has_path_sum(root, 22)}")  # 10->5->7
print(f"All paths with sum 18: {find_all_paths(root, 18)}")  # 10->5->3

print("\n📏 Pattern 3: Diameter")
print(f"Diameter: {diameter_of_tree(root)}")

print("\n🪞 Pattern 4: Symmetry")
symmetric_tree = build_symmetric_tree()
print(f"Is symmetric? {is_symmetric(symmetric_tree)}")

print("\n🔄 Pattern 5: Invert Tree")
print("Tree inverted!")
invert_tree(root)

print("\n👥 Pattern 6: Lowest Common Ancestor")
print(f"LCA of 3 and 7: {lca_bst(root, 3, 7)}")

print("\n🔢 Pattern 7: Kth Smallest")
print(f"2nd smallest: {kth_smallest_bst(root, 2)}")

print("\n✅ Pattern 8: Validate BST")
print(f"Is valid BST? {is_valid_bst(root)}")

print("\n⚡ Pattern 9: Zigzag Level Order")
print(f"Zigzag: {zigzag_level_order(root)}")

print("\n💾 Pattern 10: Serialize/Deserialize")
serialized = serialize(root)
print(f"Serialized: {serialized[:50]}...")
deserialized = deserialize(serialized)
print("Deserialized successfully!")

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)
print("\n✓ Most tree problems use DFS or BFS")
print("✓ Recursion is natural for trees")
print("✓ BST problems often use BST property")
print("✓ Path problems use backtracking")
print("✓ Level problems use BFS/queue")
