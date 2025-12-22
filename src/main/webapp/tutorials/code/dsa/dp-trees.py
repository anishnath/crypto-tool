"""
DP on Trees
Max Path Sum, Diameter, House Robber III, and other tree DP problems
"""

class TreeNode:
    """Binary Tree Node"""
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

# ============================================================================
# MAXIMUM PATH SUM (BINARY TREE)
# ============================================================================

def max_path_sum(root):
    """
    Maximum Path Sum: Maximum sum path in binary tree (any node to any node)
    
    Returns maximum path sum
    Uses post-order traversal with DP
    """
    max_sum = [float('-inf')]  # Use list to pass by reference
    
    def dfs(node):
        if not node:
            return 0
        
        # Get max path from left and right subtrees
        left_sum = max(0, dfs(node.left))   # Ignore negative sums
        right_sum = max(0, dfs(node.right))
        
        # Current path sum: node + left + right
        current_sum = node.val + left_sum + right_sum
        max_sum[0] = max(max_sum[0], current_sum)
        
        # Return max path that can be extended to parent
        return node.val + max(left_sum, right_sum)
    
    dfs(root)
    return max_sum[0]

# ============================================================================
# DIAMETER OF BINARY TREE
# ============================================================================

def diameter_of_binary_tree(root):
    """
    Diameter: Longest path between any two nodes (number of edges)
    
    For each node, diameter = max depth of left + max depth of right
    """
    max_diameter = [0]
    
    def dfs(node):
        if not node:
            return 0
        
        left_depth = dfs(node.left)
        right_depth = dfs(node.right)
        
        # Diameter passing through this node
        current_diameter = left_depth + right_depth
        max_diameter[0] = max(max_diameter[0], current_diameter)
        
        # Return max depth from this node
        return max(left_depth, right_depth) + 1
    
    dfs(root)
    return max_diameter[0]

# ============================================================================
# HOUSE ROBBER III
# ============================================================================

def house_robber_iii(root):
    """
    House Robber III: Binary tree of houses, can't rob connected nodes
    
    Returns [rob_this_node, skip_this_node]
    """
    def dfs(node):
        if not node:
            return [0, 0]  # [rob, skip]
        
        left = dfs(node.left)
        right = dfs(node.right)
        
        # Rob this node: must skip children
        rob = node.val + left[1] + right[1]
        
        # Skip this node: can choose best from children
        skip = max(left) + max(right)
        
        return [rob, skip]
    
    result = dfs(root)
    return max(result)

# ============================================================================
# BINARY TREE MAXIMUM PATH SUM (ALGORITHM EXPLANATION)
# ============================================================================

def max_path_sum_explained(root):
    """
    Detailed explanation of max path sum algorithm
    """
    print(f"\n🌳 Maximum Path Sum in Binary Tree")
    
    max_sum = [float('-inf')]
    
    def dfs(node, path=""):
        if not node:
            return 0
        
        current_path = f"{path} -> {node.val}" if path else str(node.val)
        print(f"   Visiting node: {node.val} (path: {current_path})")
        
        left_sum = max(0, dfs(node.left, current_path))
        right_sum = max(0, dfs(node.right, current_path))
        
        print(f"   Node {node.val}: left_sum={left_sum}, right_sum={right_sum}")
        
        current_sum = node.val + left_sum + right_sum
        max_sum[0] = max(max_sum[0], current_sum)
        print(f"   Current path sum through {node.val}: {current_sum}")
        print(f"   Global max so far: {max_sum[0]}")
        
        return_val = node.val + max(left_sum, right_sum)
        print(f"   Returning to parent: {return_val} (can extend this path)")
        return return_val
    
    dfs(root)
    print(f"\n✓ Maximum path sum: {max_sum[0]}")
    return max_sum[0]

# ============================================================================
# LONGEST PATH IN TREE
# ============================================================================

def longest_path_in_tree(root):
    """
    Longest path (not necessarily diameter) in tree
    Similar to diameter but with different constraint
    """
    max_path = [0]
    
    def dfs(node):
        if not node:
            return 0
        
        left = dfs(node.left)
        right = dfs(node.right)
        
        # Longest path through this node
        through_node = left + right + 1
        max_path[0] = max(max_path[0], through_node)
        
        # Return longest path from this node downward
        return max(left, right) + 1
    
    dfs(root)
    return max_path[0] - 1  # Subtract 1 to get number of edges

# ============================================================================
# SUM OF ALL LEFT LEAVES
# ============================================================================

def sum_of_left_leaves(root):
    """
    Sum of all left leaves in binary tree
    DP-style: track if node is left child
    """
    total = [0]
    
    def dfs(node, is_left=False):
        if not node:
            return
        
        if not node.left and not node.right and is_left:
            total[0] += node.val
        
        dfs(node.left, True)
        dfs(node.right, False)
    
    dfs(root)
    return total[0]

# ============================================================================
# MAXIMUM AVERAGE SUBTREE
# ============================================================================

def maximum_average_subtree(root):
    """
    Maximum average value in any subtree
    Returns max average
    """
    max_avg = [float('-inf')]
    
    def dfs(node):
        if not node:
            return [0, 0]  # [sum, count]
        
        left = dfs(node.left)
        right = dfs(node.right)
        
        total_sum = node.val + left[0] + right[0]
        total_count = 1 + left[1] + right[1]
        
        avg = total_sum / total_count
        max_avg[0] = max(max_avg[0], avg)
        
        return [total_sum, total_count]
    
    dfs(root)
    return max_avg[0]

# ============================================================================
# TREE DP PATTERNS
# ============================================================================

def tree_dp_patterns():
    """
    Common patterns for DP on trees
    """
    print("\n" + "=" * 70)
    print("Tree DP Patterns")
    print("=" * 70)
    
    print("\n🌳 Key Insight:")
    print("   Tree DP uses DFS (post-order traversal)")
    print("   Process children first, then current node")
    
    print("\n📋 Common Patterns:")
    print("   1. Bottom-up: Return value from children, compute current")
    print("   2. Pass-by-reference: Use list/array for global maximum")
    print("   3. Two states: Often return [with_node, without_node]")
    
    print("\n🔑 State Definition:")
    print("   • Return value: Best path/sum from this node downward")
    print("   • Global variable: Best overall answer across all nodes")
    
    print("\n💡 Example Pattern:")
    print("   def dfs(node):")
    print("       if not node: return 0")
    print("       left = dfs(node.left)")
    print("       right = dfs(node.right)")
    print("       current = compute(node, left, right)")
    print("       global_max = max(global_max, current)")
    print("       return extend_to_parent(node, left, right)")

# ============================================================================
# EXAMPLE 1: Maximum Path Sum
# ============================================================================

print("=" * 70)
print("Example 1: Maximum Path Sum")
print("=" * 70)

# Create example tree: [-10, 9, 20, null, null, 15, 7]
root1 = TreeNode(-10)
root1.left = TreeNode(9)
root1.right = TreeNode(20)
root1.right.left = TreeNode(15)
root1.right.right = TreeNode(7)

print(f"   Tree structure:")
print(f"        -10")
print(f"       /  \\")
print(f"      9    20")
print(f"          /  \\")
print(f"         15   7")

result1 = max_path_sum(root1)
print(f"\n✓ Maximum path sum: {result1}")

# ============================================================================
# EXAMPLE 2: Diameter of Binary Tree
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Diameter of Binary Tree")
print("=" * 70)

# Create example tree: [1, 2, 3, 4, 5]
root2 = TreeNode(1)
root2.left = TreeNode(2)
root2.right = TreeNode(3)
root2.left.left = TreeNode(4)
root2.left.right = TreeNode(5)

diameter = diameter_of_binary_tree(root2)
print(f"\n✓ Diameter: {diameter} edges")

# ============================================================================
# EXAMPLE 3: House Robber III
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: House Robber III")
print("=" * 70)

# Create example tree: [3, 2, 3, null, 3, null, 1]
root3 = TreeNode(3)
root3.left = TreeNode(2)
root3.right = TreeNode(3)
root3.left.right = TreeNode(3)
root3.right.right = TreeNode(1)

max_rob = house_robber_iii(root3)
print(f"\n✓ Maximum money robbed: {max_rob}")

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Problem':<35} {'Time':<25} {'Space'}")
print("─" * 85)
print(f"{'Max Path Sum':<35} {'O(n)':<25} {'O(h)'}")
print(f"{'Diameter':<35} {'O(n)':<25} {'O(h)'}")
print(f"{'House Robber III':<35} {'O(n)':<25} {'O(h)'}")
print(f"\n   n = number of nodes, h = height of tree (O(log n) balanced, O(n) worst)")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Tree DP uses post-order DFS (children first)")
print("✓ Return value: best path/value from node downward")
print("✓ Global variable: best overall answer")
print("✓ Common pattern: process children, compute current, update global")
print("✓ Max Path Sum: node + left + right, return node + max(left, right)")
print("✓ Diameter: left_depth + right_depth, return max_depth + 1")
print("✓ House Robber III: [rob_node, skip_node] state")

tree_dp_patterns()
