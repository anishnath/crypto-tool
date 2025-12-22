"""
2D Dynamic Programming Problems
LCS, Edit Distance, Unique Paths, and other matrix/grid DP problems
"""

# ============================================================================
# UNIQUE PATHS
# ============================================================================

def unique_paths(m, n):
    """
    Unique Paths: Robot at (0,0), can move right or down
    How many paths to (m-1, n-1)?
    
    dp[i][j] = paths to reach (i, j)
    dp[i][j] = dp[i-1][j] + dp[i][j-1]
    """
    print(f"\n🛤️ Unique Paths")
    print(f"   Grid: {m}×{n}")
    
    dp = [[0] * n for _ in range(m)]
    dp[0][0] = 1
    
    # First row: only right moves
    for j in range(1, n):
        dp[0][j] = 1
    
    # First column: only down moves
    for i in range(1, m):
        dp[i][0] = 1
    
    # Fill rest
    for i in range(1, m):
        for j in range(1, n):
            dp[i][j] = dp[i - 1][j] + dp[i][j - 1]
    
    print(f"\n✓ Unique paths: {dp[m - 1][n - 1]}")
    return dp[m - 1][n - 1]

def unique_paths_with_obstacles(grid):
    """
    Unique Paths II: Grid has obstacles (1 = obstacle, 0 = empty)
    dp[i][j] = paths to (i,j) avoiding obstacles
    """
    print(f"\n🛤️ Unique Paths with Obstacles")
    print(f"   Grid: {grid}")
    
    m, n = len(grid), len(grid[0])
    dp = [[0] * n for _ in range(m)]
    
    # Base case: start position
    dp[0][0] = 1 if grid[0][0] == 0 else 0
    
    # First row
    for j in range(1, n):
        dp[0][j] = dp[0][j - 1] if grid[0][j] == 0 else 0
    
    # First column
    for i in range(1, m):
        dp[i][0] = dp[i - 1][0] if grid[i][0] == 0 else 0
    
    # Fill rest
    for i in range(1, m):
        for j in range(1, n):
            if grid[i][j] == 0:
                dp[i][j] = dp[i - 1][j] + dp[i][j - 1]
            else:
                dp[i][j] = 0
    
    print(f"\n✓ Unique paths: {dp[m - 1][n - 1]}")
    return dp[m - 1][n - 1]

# ============================================================================
# LONGEST COMMON SUBSEQUENCE (LCS)
# ============================================================================

def longest_common_subsequence(text1, text2):
    """
    LCS: Longest common subsequence between two strings
    
    dp[i][j] = LCS length of text1[0:i] and text2[0:j]
    dp[i][j] = dp[i-1][j-1] + 1 if text1[i-1] == text2[j-1]
             = max(dp[i-1][j], dp[i][j-1]) otherwise
    """
    print(f"\n📝 Longest Common Subsequence")
    print(f"   Text1: {text1}")
    print(f"   Text2: {text2}")
    
    m, n = len(text1), len(text2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if text1[i - 1] == text2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
    
    print(f"\n✓ LCS length: {dp[m][n]}")
    return dp[m][n]

def lcs_reconstruct(text1, text2, dp):
    """Reconstruct LCS string from DP table"""
    i, j = len(text1), len(text2)
    lcs = []
    
    while i > 0 and j > 0:
        if text1[i - 1] == text2[j - 1]:
            lcs.append(text1[i - 1])
            i -= 1
            j -= 1
        elif dp[i - 1][j] > dp[i][j - 1]:
            i -= 1
        else:
            j -= 1
    
    return ''.join(reversed(lcs))

# ============================================================================
# EDIT DISTANCE (LEVENSHTEIN)
# ============================================================================

def edit_distance(word1, word2):
    """
    Edit Distance: Minimum operations to convert word1 to word2
    Operations: Insert, Delete, Replace
    
    dp[i][j] = edit distance between word1[0:i] and word2[0:j]
    dp[i][j] = dp[i-1][j-1] if word1[i-1] == word2[j-1]
             = min(
                 dp[i-1][j] + 1,      # Delete from word1
                 dp[i][j-1] + 1,      # Insert into word1
                 dp[i-1][j-1] + 1     # Replace
               )
    """
    print(f"\n✏️ Edit Distance (Levenshtein)")
    print(f"   Word1: {word1}")
    print(f"   Word2: {word2}")
    
    m, n = len(word1), len(word2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    # Base cases
    for i in range(m + 1):
        dp[i][0] = i  # Delete all characters from word1
    for j in range(n + 1):
        dp[0][j] = j  # Insert all characters into word1
    
    # Fill DP table
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if word1[i - 1] == word2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1]
            else:
                dp[i][j] = min(
                    dp[i - 1][j] + 1,      # Delete
                    dp[i][j - 1] + 1,      # Insert
                    dp[i - 1][j - 1] + 1   # Replace
                )
    
    print(f"\n✓ Edit distance: {dp[m][n]}")
    return dp[m][n]

# ============================================================================
# MAXIMUM SQUARE IN MATRIX
# ============================================================================

def maximal_square(matrix):
    """
    Maximal Square: Largest square of 1s in binary matrix
    dp[i][j] = side length of largest square ending at (i, j)
    dp[i][j] = min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + 1 if matrix[i][j] == 1
             = 0 otherwise
    """
    print(f"\n⬜ Maximal Square")
    print(f"   Matrix: {matrix}")
    
    if not matrix:
        return 0
    
    m, n = len(matrix), len(matrix[0])
    dp = [[0] * n for _ in range(m)]
    max_side = 0
    
    # First row and column
    for i in range(m):
        dp[i][0] = int(matrix[i][0])
        max_side = max(max_side, dp[i][0])
    for j in range(n):
        dp[0][j] = int(matrix[0][j])
        max_side = max(max_side, dp[0][j])
    
    # Fill rest
    for i in range(1, m):
        for j in range(1, n):
            if matrix[i][j] == '1':
                dp[i][j] = min(dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]) + 1
                max_side = max(max_side, dp[i][j])
    
    area = max_side * max_side
    print(f"\n✓ Maximal square area: {area} (side: {max_side})")
    return area

# ============================================================================
# MINIMUM PATH SUM
# ============================================================================

def min_path_sum(grid):
    """
    Minimum Path Sum: Minimum sum path from top-left to bottom-right
    dp[i][j] = minimum sum to reach (i, j)
    dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1])
    """
    print(f"\n📉 Minimum Path Sum")
    print(f"   Grid: {grid}")
    
    m, n = len(grid), len(grid[0])
    dp = [[0] * n for _ in range(m)]
    
    # Base case
    dp[0][0] = grid[0][0]
    
    # First row
    for j in range(1, n):
        dp[0][j] = dp[0][j - 1] + grid[0][j]
    
    # First column
    for i in range(1, m):
        dp[i][0] = dp[i - 1][0] + grid[i][0]
    
    # Fill rest
    for i in range(1, m):
        for j in range(1, n):
            dp[i][j] = grid[i][j] + min(dp[i - 1][j], dp[i][j - 1])
    
    print(f"\n✓ Minimum path sum: {dp[m - 1][n - 1]}")
    return dp[m - 1][n - 1]

# ============================================================================
# EXAMPLE 1: Unique Paths
# ============================================================================

print("=" * 70)
print("Example 1: Unique Paths")
print("=" * 70)

unique_paths(3, 7)

# ============================================================================
# EXAMPLE 2: Longest Common Subsequence
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Longest Common Subsequence")
print("=" * 70)

text1 = "abcde"
text2 = "ace"
longest_common_subsequence(text1, text2)

# ============================================================================
# EXAMPLE 3: Edit Distance
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Edit Distance")
print("=" * 70)

edit_distance("horse", "ros")

# ============================================================================
# EXAMPLE 4: Minimum Path Sum
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Minimum Path Sum")
print("=" * 70)

grid1 = [
    [1, 3, 1],
    [1, 5, 1],
    [4, 2, 1]
]
min_path_sum(grid1)

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Problem':<30} {'Time':<25} {'Space'}")
print("─" * 75)
print(f"{'Unique Paths':<30} {'O(m × n)':<25} {'O(m × n)'}")
print(f"{'LCS':<30} {'O(m × n)':<25} {'O(m × n)'}")
print(f"{'Edit Distance':<30} {'O(m × n)':<25} {'O(m × n)'}")
print(f"{'Min Path Sum':<30} {'O(m × n)':<25} {'O(m × n)'}")
print(f"{'Maximal Square':<30} {'O(m × n)':<25} {'O(m × n)'}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ 2D DP uses matrix dp[i][j]")
print("✓ State: dp[i][j] = answer for subproblem at position (i, j)")
print("✓ Common patterns: Path counting, matching, optimization on grid")
print("✓ Unique Paths: dp[i][j] = dp[i-1][j] + dp[i][j-1]")
print("✓ LCS: Match (diagonal) or skip (left/up)")
print("✓ Edit Distance: min of insert, delete, replace")
print("✓ Think in terms of grid/matrix traversal")
