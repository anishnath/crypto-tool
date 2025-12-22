"""
Advanced DP Patterns
Bitmask DP, Digit DP, State Compression
"""

# ============================================================================
# TRAVELING SALESMAN PROBLEM (TSP) WITH BITMASK
# ============================================================================

def tsp_bitmask(distances):
    """
    TSP using Bitmask DP
    distances[i][j] = distance from city i to city j
    
    dp[mask][last] = minimum cost to visit all cities in mask, ending at last
    mask: bitmask representing visited cities
    """
    print(f"\n🗺️ Traveling Salesman Problem (Bitmask DP)")
    print(f"   Cities: {len(distances)}")
    
    n = len(distances)
    # dp[mask][last] = minimum cost
    dp = [[float('inf')] * n for _ in range(1 << n)]
    
    # Base case: starting from city 0
    dp[1][0] = 0  # mask = 1 means only city 0 visited
    
    # Try all masks
    for mask in range(1, 1 << n):
        for last in range(n):
            if not (mask & (1 << last)):
                continue  # last city not in mask
            
            # Try extending path
            for next_city in range(n):
                if mask & (1 << next_city):
                    continue  # Already visited
                
                new_mask = mask | (1 << next_city)
                dp[new_mask][next_city] = min(
                    dp[new_mask][next_city],
                    dp[mask][last] + distances[last][next_city]
                )
    
    # Return to starting city
    final_mask = (1 << n) - 1  # All cities visited
    result = float('inf')
    for last in range(n):
        result = min(result, dp[final_mask][last] + distances[last][0])
    
    print(f"\n✓ Minimum TSP cost: {result}")
    return result

# ============================================================================
# ASSIGNMENT PROBLEM WITH BITMASK
# ============================================================================

def assignment_problem_bitmask(cost_matrix):
    """
    Assignment Problem: Assign n tasks to n workers with minimum cost
    Uses bitmask to represent assigned tasks
    """
    print(f"\n👥 Assignment Problem (Bitmask DP)")
    print(f"   Workers: {len(cost_matrix)}, Tasks: {len(cost_matrix[0])}")
    
    n = len(cost_matrix)
    # dp[mask] = minimum cost to assign tasks in mask
    dp = [float('inf')] * (1 << n)
    dp[0] = 0  # No tasks assigned
    
    for mask in range(1 << n):
        # Count assigned tasks
        assigned = bin(mask).count('1')
        
        if assigned >= n:
            continue
        
        # Try assigning next task to worker 'assigned'
        for task in range(n):
            if mask & (1 << task):
                continue  # Task already assigned
            
            new_mask = mask | (1 << task)
            dp[new_mask] = min(dp[new_mask], dp[mask] + cost_matrix[assigned][task])
    
    result = dp[(1 << n) - 1]
    print(f"\n✓ Minimum assignment cost: {result}")
    return result

# ============================================================================
# DIGIT DP: COUNT NUMBERS WITH CONSTRAINTS
# ============================================================================

def count_numbers_with_constraint(n, condition):
    """
    Digit DP: Count numbers from 0 to n that satisfy condition
    Example: Count numbers with no consecutive digits
    """
    s = str(n)
    digits = [int(c) for c in s]
    
    def dfs(pos, tight, prev, memo):
        """
        pos: current position
        tight: whether previous digits match n
        prev: previous digit
        memo: memoization
        """
        if pos == len(digits):
            return 1
        
        key = (pos, tight, prev)
        if key in memo:
            return memo[key]
        
        limit = digits[pos] if tight else 9
        count = 0
        
        for d in range(limit + 1):
            new_tight = tight and (d == limit)
            # Condition: no consecutive same digits
            if d != prev:
                count += dfs(pos + 1, new_tight, d, memo)
        
        memo[key] = count
        return count
    
    return dfs(0, True, -1, {})

# ============================================================================
# STATE COMPRESSION: PROFIT SCHEDULING
# ============================================================================

def max_profit_scheduling(startTime, endTime, profit):
    """
    Job Scheduling with State Compression
    Maximize profit by scheduling non-overlapping jobs
    """
    print(f"\n📅 Job Scheduling (State Compression)")
    
    n = len(startTime)
    jobs = sorted(zip(endTime, startTime, profit))
    
    # dp[i] = maximum profit using first i jobs
    dp = [0] * (n + 1)
    
    for i in range(1, n + 1):
        end, start, prof = jobs[i - 1]
        
        # Don't take job i
        dp[i] = dp[i - 1]
        
        # Take job i - find last compatible job
        # Binary search for last job ending <= start
        left, right = 0, i - 1
        last_compatible = -1
        
        while left <= right:
            mid = (left + right) // 2
            if jobs[mid][0] <= start:
                last_compatible = mid
                left = mid + 1
            else:
                right = mid - 1
        
        if last_compatible != -1:
            dp[i] = max(dp[i], dp[last_compatible + 1] + prof)
        else:
            dp[i] = max(dp[i], prof)
    
    print(f"\n✓ Maximum profit: {dp[n]}")
    return dp[n]

# ============================================================================
# BITMASK SUBSET DP
# ============================================================================

def bitmask_subset_dp_example(n):
    """
    Example: Count all subsets that sum to target using bitmask
    """
    print(f"\n🔢 Bitmask Subset DP Example")
    print(f"   Total subsets of {n} elements: {2**n}")
    
    count = 0
    for mask in range(1 << n):
        # Process subset represented by mask
        subset = [i for i in range(n) if mask & (1 << i)]
        count += 1
    
    print(f"   Total subsets: {count}")
    return count

# ============================================================================
# PALINDROME PARTITIONING (BITMASK APPROACH)
# ============================================================================

def palindrome_partitioning_bitmask(s):
    """
    Minimum palindrome partitioning using bitmask
    """
    n = len(s)
    if not s:
        return 0
    
    # Precompute palindromes
    is_pal = [[False] * n for _ in range(n)]
    for i in range(n):
        is_pal[i][i] = True
    for i in range(n - 1):
        is_pal[i][i + 1] = (s[i] == s[i + 1])
    for length in range(3, n + 1):
        for i in range(n - length + 1):
            j = i + length - 1
            is_pal[i][j] = (s[i] == s[j] and is_pal[i + 1][j - 1])
    
    # Bitmask DP
    dp = [float('inf')] * (1 << n)
    dp[0] = 0
    
    for mask in range(1, 1 << n):
        # Find last set bit
        last = mask.bit_length() - 1
        
        # Try all possible endings
        for end in range(last + 1):
            if not (mask & (1 << end)):
                continue
            
            # Check if substring is palindrome
            start = 0
            for i in range(end + 1):
                if mask & (1 << i):
                    start = i
                    break
            
            if is_pal[start][end]:
                prev_mask = mask & ~((1 << (end + 1)) - 1) | ((1 << start) - 1)
                dp[mask] = min(dp[mask], dp[prev_mask] + 1)
    
    return dp[(1 << n) - 1]

# ============================================================================
# BITMASK DP PATTERNS
# ============================================================================

def bitmask_dp_patterns():
    """
    Common patterns for Bitmask DP
    """
    print("\n" + "=" * 70)
    print("Bitmask DP Patterns")
    print("=" * 70)
    
    print("\n🔑 Key Concepts:")
    print("   • Bitmask: Integer representing set (1 = included, 0 = excluded)")
    print("   • mask & (1 << i): Check if element i is in set")
    print("   • mask | (1 << i): Add element i to set")
    print("   • mask ^ (1 << i): Toggle element i in set")
    print("   • (1 << n) - 1: All n elements included")
    
    print("\n📋 Common Problems:")
    print("   1. TSP: Visit all cities exactly once")
    print("   2. Assignment: Assign tasks to workers")
    print("   3. Subset DP: Optimize over all subsets")
    print("   4. State Compression: Reduce state space")
    
    print("\n💡 State Definition:")
    print("   dp[mask][additional_state] = answer for subset mask")
    print("   Example: dp[mask][last] = min cost to visit mask, ending at last")

# ============================================================================
# EXAMPLE 1: TSP with Bitmask
# ============================================================================

print("=" * 70)
print("Example 1: Traveling Salesman Problem")
print("=" * 70)

# Example: 4 cities
distances = [
    [0, 10, 15, 20],
    [10, 0, 35, 25],
    [15, 35, 0, 30],
    [20, 25, 30, 0]
]

tsp_bitmask(distances)

# ============================================================================
# EXAMPLE 2: Assignment Problem
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Assignment Problem")
print("=" * 70)

cost_matrix = [
    [9, 2, 7, 8],
    [6, 4, 3, 7],
    [5, 8, 1, 8],
    [7, 6, 9, 4]
]

assignment_problem_bitmask(cost_matrix)

# ============================================================================
# EXAMPLE 3: Bitmask Subset DP
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Bitmask Subset DP")
print("=" * 70)

bitmask_subset_dp_example(4)

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Problem':<35} {'Time':<30} {'Space'}")
print("─" * 95)
print(f"{'TSP (Bitmask)':<35} {'O(2^n × n²)':<30} {'O(2^n × n)'}")
print(f"{'Assignment (Bitmask)':<35} {'O(2^n × n)':<30} {'O(2^n)'}")
print(f"{'Digit DP':<35} {'O(log n × states)':<30} {'O(log n × states)'}")
print(f"\n   Note: Bitmask DP is exponential in n, but efficient for n ≤ 20")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Bitmask DP: Use integers to represent sets")
print("✓ Efficient for small sets (typically n ≤ 20)")
print("✓ State: dp[mask] or dp[mask][additional_state]")
print("✓ TSP: Classic bitmask DP problem")
print("✓ Digit DP: Process digits one by one with constraints")
print("✓ State Compression: Reduce state space using clever encoding")

bitmask_dp_patterns()
