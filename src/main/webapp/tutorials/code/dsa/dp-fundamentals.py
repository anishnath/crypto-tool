"""
Dynamic Programming Fundamentals
Memoization vs Tabulation, Fibonacci, Climbing Stairs
"""

# ============================================================================
# FIBONACCI - NAIVE RECURSION (SLOW)
# ============================================================================

def fibonacci_naive(n):
    """
    Naive recursive Fibonacci
    Time: O(2^n) - Exponential!
    Space: O(n) - Recursion stack
    """
    if n <= 1:
        return n
    return fibonacci_naive(n - 1) + fibonacci_naive(n - 2)

# ============================================================================
# FIBONACCI - MEMOIZATION (TOP-DOWN)
# ============================================================================

def fibonacci_memo(n, memo=None):
    """
    Fibonacci with memoization (top-down DP)
    Time: O(n), Space: O(n)
    """
    if memo is None:
        memo = {}
    
    if n in memo:
        return memo[n]
    
    if n <= 1:
        return n
    
    memo[n] = fibonacci_memo(n - 1, memo) + fibonacci_memo(n - 2, memo)
    return memo[n]

def fibonacci_memo_clean(n):
    """Cleaner memoization with decorator pattern"""
    memo = {}
    
    def fib(k):
        if k in memo:
            return memo[k]
        if k <= 1:
            return k
        memo[k] = fib(k - 1) + fib(k - 2)
        return memo[k]
    
    return fib(n)

# ============================================================================
# FIBONACCI - TABULATION (BOTTOM-UP)
# ============================================================================

def fibonacci_tabulation(n):
    """
    Fibonacci with tabulation (bottom-up DP)
    Time: O(n), Space: O(n)
    """
    if n <= 1:
        return n
    
    dp = [0] * (n + 1)
    dp[1] = 1
    
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]
    
    return dp[n]

def fibonacci_optimized(n):
    """
    Space-optimized Fibonacci
    Only need last two values!
    Time: O(n), Space: O(1)
    """
    if n <= 1:
        return n
    
    prev2, prev1 = 0, 1
    
    for i in range(2, n + 1):
        current = prev1 + prev2
        prev2, prev1 = prev1, current
    
    return prev1

# ============================================================================
# CLIMBING STAIRS PROBLEM
# ============================================================================

def climb_stairs(n):
    """
    Climbing Stairs: Can climb 1 or 2 steps at a time
    How many ways to reach top?
    
    This is essentially Fibonacci!
    dp[i] = ways to reach step i
    dp[i] = dp[i-1] + dp[i-2]
    """
    if n <= 2:
        return n
    
    dp = [0] * (n + 1)
    dp[1] = 1
    dp[2] = 2
    
    for i in range(3, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]
    
    return dp[n]

def climb_stairs_optimized(n):
    """Space-optimized climbing stairs"""
    if n <= 2:
        return n
    
    prev2, prev1 = 1, 2
    
    for i in range(3, n + 1):
        current = prev1 + prev2
        prev2, prev1 = prev1, current
    
    return prev1

def climb_stairs_variable(n, steps):
    """
    General climbing stairs: Can take steps from allowed list
    dp[i] = sum of dp[i-step] for step in steps
    """
    if n == 0:
        return 1
    if n < 0:
        return 0
    
    dp = [0] * (n + 1)
    dp[0] = 1  # One way to stay at ground (do nothing)
    
    for i in range(1, n + 1):
        for step in steps:
            if i >= step:
                dp[i] += dp[i - step]
    
    return dp[n]

# ============================================================================
# MEMOIZATION VS TABULATION
# ============================================================================

def compare_memoization_tabulation():
    """
    Comparison of memoization and tabulation
    """
    print("\n" + "=" * 70)
    print("Memoization vs Tabulation")
    print("=" * 70)
    
    print("\n{'Aspect':<25} {'Memoization (Top-Down)':<30} {'Tabulation (Bottom-Up)'}")
    print("─" * 85)
    print(f"{'Approach':<25} {'Recursive + cache':<30} {'Iterative + table'}")
    print(f"{'Think':<25} {'How do I get to n?':<30} {'Build from base cases'}")
    print(f"{'Space (stack)':<25} {'O(n) recursion':<30} {'No recursion'}")
    print(f"{'Space (table)':<25} {'O(n) memo dict':<30} {'O(n) dp array'}")
    print(f"{'Time':<25} {'O(n)':<30} {'O(n)'}")
    print(f"{'Subproblems solved':<25} {'Only needed ones':<30} {'All subproblems'}")
    print(f"{'When to use':<25} {'Natural recursion':<30} {'Avoid stack overflow'}")
    
    print("\n💡 Memoization (Top-Down):")
    print("   • More intuitive - think recursively")
    print("   • Only solves needed subproblems")
    print("   • Uses recursion stack (can overflow)")
    print("   • Example: Fibonacci_memo")
    
    print("\n💡 Tabulation (Bottom-Up):")
    print("   • Build up from base cases")
    print("   • Solves all subproblems")
    print("   • No recursion (more control)")
    print("   • Example: Fibonacci_tabulation")
    
    print("\n💡 Both are DP - choose based on problem and constraints!")

# ============================================================================
# DP KEY PRINCIPLES
# ============================================================================

def dp_key_insights():
    """
    Key insights for recognizing DP problems
    """
    print("\n" + "=" * 70)
    print("Key DP Insights")
    print("=" * 70)
    
    print("\n✓ Overlapping Subproblems:")
    print("   Same subproblem solved multiple times")
    print("   Example: fibonacci(5) needs fibonacci(3) twice")
    
    print("\n✓ Optimal Substructure:")
    print("   Optimal solution contains optimal solutions to subproblems")
    print("   Example: Best path to (i,j) uses best paths to (i-1,j) and (i,j-1)")
    
    print("\n✓ State Definition:")
    print("   dp[i] or dp[i][j] = answer to subproblem")
    print("   Example: dp[i] = ways to reach step i")
    
    print("\n✓ Transition (Recurrence Relation):")
    print("   How to compute dp[i] from previous states")
    print("   Example: dp[i] = dp[i-1] + dp[i-2]")
    
    print("\n✓ Base Cases:")
    print("   Smallest subproblems (no dependencies)")
    print("   Example: dp[0] = 0, dp[1] = 1")

# ============================================================================
# EXAMPLE 1: Fibonacci Comparison
# ============================================================================

print("=" * 70)
print("Example 1: Fibonacci - Different Approaches")
print("=" * 70)

n = 10

print(f"\nFibonacci({n}):")
print(f"   Naive recursion: {fibonacci_naive(n)}")
print(f"   Memoization: {fibonacci_memo(n)}")
print(f"   Tabulation: {fibonacci_tabulation(n)}")
print(f"   Optimized: {fibonacci_optimized(n)}")

# ============================================================================
# EXAMPLE 2: Climbing Stairs
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Climbing Stairs")
print("=" * 70)

stairs = 5
print(f"\nWays to climb {stairs} stairs (1 or 2 steps): {climb_stairs(stairs)}")
print(f"   (This is fibonacci({stairs + 1}))")

print(f"\nWays to climb {stairs} stairs with steps [1, 2, 3]: {climb_stairs_variable(stairs, [1, 2, 3])}")

# ============================================================================
# EXAMPLE 3: Comparison
# ============================================================================

compare_memoization_tabulation()
dp_key_insights()

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Approach':<30} {'Time':<20} {'Space':<20}")
print("─" * 70)
print(f"{'Naive Recursion':<30} {'O(2^n)':<20} {'O(n)'}")
print(f"{'Memoization':<30} {'O(n)':<20} {'O(n)'}")
print(f"{'Tabulation':<30} {'O(n)':<20} {'O(n)'}")
print(f"{'Optimized Tabulation':<30} {'O(n)':<20} {'O(1)'}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ DP = Recursion + Memoization/Tabulation")
print("✓ Two approaches: Memoization (top-down) and Tabulation (bottom-up)")
print("✓ Key properties: Overlapping subproblems + Optimal substructure")
print("✓ Fibonacci is the classic DP example")
print("✓ Climbing stairs is Fibonacci in disguise")
print("✓ Space can often be optimized from O(n) to O(1)")
print("✓ Think: State definition → Transition → Base cases")
