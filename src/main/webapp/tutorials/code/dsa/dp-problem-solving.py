"""
DP Problem-Solving Guide
How to recognize DP, common patterns, and strategy guide
"""

# ============================================================================
# HOW TO RECOGNIZE DP PROBLEMS
# ============================================================================

def how_to_recognize_dp():
    """
    Guide to recognizing DP problems
    """
    print("=" * 70)
    print("How to Recognize DP Problems")
    print("=" * 70)
    
    print("\n🔍 Key Indicators:")
    print("   1. Optimization Problem (min, max, count)")
    print("   2. Overlapping Subproblems (same problem solved multiple times)")
    print("   3. Optimal Substructure (optimal solution contains optimal subproblems)")
    print("   4. Can be broken into smaller subproblems")
    
    print("\n📝 Common Problem Types:")
    print("   • Maximize/Minimize value (profit, cost, path sum)")
    print("   • Count possibilities (ways, paths, combinations)")
    print("   • Decision problems (can we form? is it possible?)")
    print("   • Path/Movement problems (grid, graph traversal)")
    print("   • Sequence problems (arrays, strings)")
    
    print("\n❓ Questions to Ask:")
    print("   • Can I solve smaller version of this problem?")
    print("   • Does the answer for bigger problem depend on smaller ones?")
    print("   • Am I recomputing the same subproblem multiple times?")
    print("   • Is there a recurrence relation I can write?")

# ============================================================================
# COMMON DP PATTERNS
# ============================================================================

def common_dp_patterns():
    """
    Summary of common DP patterns
    """
    print("\n" + "=" * 70)
    print("Common DP Patterns")
    print("=" * 70)
    
    patterns = [
        {
            "name": "1D DP - Linear",
            "examples": ["Fibonacci", "Climbing Stairs", "House Robber"],
            "state": "dp[i] = answer for first i elements",
            "transition": "dp[i] = f(dp[i-1], dp[i-2], ...)"
        },
        {
            "name": "1D DP - Array/Sequence",
            "examples": ["LIS", "Coin Change", "Decode Ways"],
            "state": "dp[i] = answer ending/at index i",
            "transition": "dp[i] = f(dp[j]) for j < i"
        },
        {
            "name": "2D DP - Grid/Matrix",
            "examples": ["Unique Paths", "Min Path Sum", "Max Square"],
            "state": "dp[i][j] = answer at position (i, j)",
            "transition": "dp[i][j] = f(dp[i-1][j], dp[i][j-1], ...)"
        },
        {
            "name": "2D DP - Two Sequences",
            "examples": ["LCS", "Edit Distance", "Interleaving String"],
            "state": "dp[i][j] = answer for first i of seq1, first j of seq2",
            "transition": "dp[i][j] = f(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])"
        },
        {
            "name": "Knapsack",
            "examples": ["0/1 Knapsack", "Unbounded Knapsack", "Subset Sum"],
            "state": "dp[i][w] = answer using first i items with capacity w",
            "transition": "dp[i][w] = max(include, exclude)"
        },
        {
            "name": "Interval DP",
            "examples": ["Matrix Chain", "Palindrome Partitioning"],
            "state": "dp[i][j] = answer for interval [i, j]",
            "transition": "dp[i][j] = f(dp[i][k], dp[k+1][j]) for k in [i, j)"
        },
        {
            "name": "Tree DP",
            "examples": ["Max Path Sum", "Diameter", "House Robber III"],
            "state": "Return value from subtree, global max",
            "transition": "Post-order DFS, combine children"
        },
        {
            "name": "Bitmask DP",
            "examples": ["TSP", "Assignment Problem"],
            "state": "dp[mask] = answer for subset mask",
            "transition": "dp[mask] = f(dp[mask'], ...)"
        }
    ]
    
    for i, pattern in enumerate(patterns, 1):
        print(f"\n{i}. {pattern['name']}")
        print(f"   Examples: {', '.join(pattern['examples'])}")
        print(f"   State: {pattern['state']}")
        print(f"   Transition: {pattern['transition']}")

# ============================================================================
# DP SOLVING STRATEGY
# ============================================================================

def dp_solving_strategy():
    """
    Step-by-step strategy for solving DP problems
    """
    print("\n" + "=" * 70)
    print("DP Solving Strategy (Step-by-Step)")
    print("=" * 70)
    
    steps = [
        {
            "step": 1,
            "title": "Understand the Problem",
            "actions": [
                "Read problem carefully",
                "Identify what to optimize (max, min, count)",
                "Understand constraints"
            ]
        },
        {
            "step": 2,
            "title": "Identify Subproblems",
            "actions": [
                "What are the smaller versions?",
                "What does answer depend on?",
                "Think recursively: How to solve using subproblems?"
            ]
        },
        {
            "step": 3,
            "title": "Define State",
            "actions": [
                "dp[i] or dp[i][j] = what?",
                "State should capture necessary information",
                "Choose minimal state space"
            ]
        },
        {
            "step": 4,
            "title": "Find Recurrence Relation",
            "actions": [
                "How to compute dp[i] from previous states?",
                "Write formula: dp[i] = f(dp[...])",
                "Consider all choices/transitions"
            ]
        },
        {
            "step": 5,
            "title": "Identify Base Cases",
            "actions": [
                "Smallest subproblems (no dependencies)",
                "Edge cases (empty, single element, etc.)",
                "Set initial values"
            ]
        },
        {
            "step": 6,
            "title": "Choose Implementation",
            "actions": [
                "Memoization (top-down): Natural recursion",
                "Tabulation (bottom-up): Iterative, avoid stack",
                "Space optimization if possible"
            ]
        },
        {
            "step": 7,
            "title": "Code and Test",
            "actions": [
                "Implement solution",
                "Test with examples",
                "Check edge cases",
                "Verify time/space complexity"
            ]
        }
    ]
    
    for step_info in steps:
        print(f"\n{step_info['step']}. {step_info['title']}")
        for action in step_info['actions']:
            print(f"   • {action}")

# ============================================================================
# COMMON MISTAKES TO AVOID
# ============================================================================

def common_mistakes():
    """
    Common mistakes in DP problems
    """
    print("\n" + "=" * 70)
    print("Common Mistakes to Avoid")
    print("=" * 70)
    
    mistakes = [
        "Not identifying overlapping subproblems",
        "Wrong state definition (too much or too little information)",
        "Incorrect recurrence relation (missing cases)",
        "Forgetting base cases",
        "Off-by-one errors in indices",
        "Not handling edge cases (empty, single element)",
        "Using wrong data structure (should use array, not dict for tabulation)",
        "Not optimizing space when possible",
        "Confusing memoization and tabulation",
        "Not considering all transitions/choices"
    ]
    
    for i, mistake in enumerate(mistakes, 1):
        print(f"   {i}. {mistake}")

# ============================================================================
# PRACTICE RECOMMENDATIONS
# ============================================================================

def practice_recommendations():
    """
    Recommendations for practicing DP
    """
    print("\n" + "=" * 70)
    print("Practice Recommendations")
    print("=" * 70)
    
    print("\n📚 Start with Basics:")
    print("   1. Fibonacci variations (Climbing Stairs, etc.)")
    print("   2. Simple 1D DP (House Robber, Coin Change)")
    print("   3. Grid problems (Unique Paths)")
    
    print("\n📈 Progress to Intermediate:")
    print("   1. 2D DP (LCS, Edit Distance)")
    print("   2. Knapsack problems")
    print("   3. String DP (Palindrome, Word Break)")
    
    print("\n🚀 Advanced Topics:")
    print("   1. Interval DP")
    print("   2. Tree DP")
    print("   3. Bitmask DP")
    
    print("\n💡 Practice Strategy:")
    print("   • Solve same problem multiple ways (memoization vs tabulation)")
    print("   • Try to optimize space complexity")
    print("   • Draw DP tables for 2D problems")
    print("   • Trace through examples manually")
    print("   • Focus on pattern recognition")

# ============================================================================
# DP TEMPLATE
# ============================================================================

def dp_template():
    """
    Generic DP template
    """
    print("\n" + "=" * 70)
    print("Generic DP Template")
    print("=" * 70)
    
    print("\n# Memoization (Top-Down)")
    print("""
def solve(n, memo={}):
    # Base cases
    if n in memo:
        return memo[n]
    if base_case(n):
        return base_value
    
    # Recurrence relation
    result = combine(solve(subproblem1), solve(subproblem2), ...)
    memo[n] = result
    return result
""")
    
    print("\n# Tabulation (Bottom-Up)")
    print("""
def solve(n):
    # Initialize DP array
    dp = [0] * (n + 1)
    
    # Base cases
    dp[0] = base_value0
    dp[1] = base_value1
    
    # Fill DP table
    for i in range(2, n + 1):
        dp[i] = combine(dp[i-1], dp[i-2], ...)
    
    return dp[n]
""")

# ============================================================================
# MAIN SUMMARY
# ============================================================================

def main():
    """Main summary function"""
    how_to_recognize_dp()
    common_dp_patterns()
    dp_solving_strategy()
    common_mistakes()
    practice_recommendations()
    dp_template()
    
    print("\n" + "=" * 70)
    print("Final Thoughts")
    print("=" * 70)
    print("\n💡 DP is a powerful technique for optimization problems")
    print("💡 Key: Identify subproblems and recurrence relation")
    print("💡 Practice pattern recognition")
    print("💡 Start simple, build up complexity")
    print("💡 Draw tables, trace examples")
    print("\n🎯 Remember: DP = Optimal Substructure + Overlapping Subproblems")

if __name__ == "__main__":
    main()
