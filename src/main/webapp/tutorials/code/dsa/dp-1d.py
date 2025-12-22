"""
1D Dynamic Programming Problems
House Robber, Coin Change, and other single-array DP problems
"""

# ============================================================================
# HOUSE ROBBER
# ============================================================================

def house_robber(houses):
    """
    House Robber: Can't rob adjacent houses
    Maximize total money robbed
    
    dp[i] = maximum money robbed up to house i
    dp[i] = max(rob house i, skip house i)
           = max(dp[i-2] + houses[i], dp[i-1])
    """
    print(f"\n🏠 House Robber Problem")
    print(f"   Houses: {houses}")
    
    if not houses:
        return 0
    if len(houses) == 1:
        return houses[0]
    
    n = len(houses)
    dp = [0] * n
    dp[0] = houses[0]
    dp[1] = max(houses[0], houses[1])
    
    print(f"   dp[0] = {dp[0]} (rob house 0)")
    print(f"   dp[1] = max({houses[0]}, {houses[1]}) = {dp[1]}")
    
    for i in range(2, n):
        # Rob current house + best from 2 houses ago
        rob_current = dp[i - 2] + houses[i]
        # Skip current house, take best from previous house
        skip_current = dp[i - 1]
        dp[i] = max(rob_current, skip_current)
        print(f"   dp[{i}] = max(rob: {rob_current}, skip: {skip_current}) = {dp[i]}")
    
    print(f"\n✓ Maximum money: {dp[n - 1]}")
    return dp[n - 1]

def house_robber_optimized(houses):
    """Space-optimized: Only need last two values"""
    if not houses:
        return 0
    if len(houses) == 1:
        return houses[0]
    
    prev2, prev1 = houses[0], max(houses[0], houses[1])
    
    for i in range(2, len(houses)):
        current = max(prev2 + houses[i], prev1)
        prev2, prev1 = prev1, current
    
    return prev1

def house_robber_circular(houses):
    """
    House Robber II: Houses arranged in circle
    First and last houses are adjacent
    """
    if not houses:
        return 0
    if len(houses) == 1:
        return houses[0]
    
    # Two cases: Rob first (exclude last) or Skip first (can include last)
    return max(
        house_robber_optimized(houses[:-1]),  # Exclude last house
        house_robber_optimized(houses[1:])     # Exclude first house
    )

# ============================================================================
# COIN CHANGE (MINIMUM COINS)
# ============================================================================

def coin_change_min(coins, amount):
    """
    Coin Change: Minimum coins to make amount
    dp[i] = minimum coins to make amount i
    dp[i] = min(dp[i-coin] + 1) for coin in coins
    """
    print(f"\n💰 Coin Change (Minimum Coins)")
    print(f"   Coins: {coins}, Amount: {amount}")
    
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0  # 0 coins to make amount 0
    
    for i in range(1, amount + 1):
        for coin in coins:
            if i >= coin:
                dp[i] = min(dp[i], dp[i - coin] + 1)
                print(f"   dp[{i}] = min(dp[{i}], dp[{i - coin}] + 1) = {dp[i]}")
    
    result = dp[amount] if dp[amount] != float('inf') else -1
    print(f"\n✓ Minimum coins: {result}")
    return result

# ============================================================================
# COIN CHANGE (NUMBER OF WAYS)
# ============================================================================

def coin_change_ways(coins, amount):
    """
    Coin Change: Number of ways to make amount
    dp[i] = number of ways to make amount i
    dp[i] = sum(dp[i-coin]) for coin in coins
    """
    print(f"\n💰 Coin Change (Number of Ways)")
    print(f"   Coins: {coins}, Amount: {amount}")
    
    dp = [0] * (amount + 1)
    dp[0] = 1  # One way to make amount 0 (use no coins)
    
    for coin in coins:
        for i in range(coin, amount + 1):
            dp[i] += dp[i - coin]
            print(f"   After coin {coin}: dp[{i}] = {dp[i]}")
    
    print(f"\n✓ Number of ways: {dp[amount]}")
    return dp[amount]

# ============================================================================
# DECODE WAYS
# ============================================================================

def decode_ways(s):
    """
    Decode Ways: 'A'=1, 'B'=2, ..., 'Z'=26
    How many ways to decode string?
    
    dp[i] = ways to decode string[0:i]
    """
    print(f"\n📝 Decode Ways")
    print(f"   String: {s}")
    
    if not s or s[0] == '0':
        return 0
    
    n = len(s)
    dp = [0] * (n + 1)
    dp[0] = 1  # Empty string = 1 way
    dp[1] = 1  # Single digit (if not '0')
    
    for i in range(2, n + 1):
        # Single digit
        if s[i - 1] != '0':
            dp[i] += dp[i - 1]
        
        # Two digits
        two_digit = int(s[i - 2:i])
        if 10 <= two_digit <= 26:
            dp[i] += dp[i - 2]
        
        print(f"   dp[{i}] = {dp[i]}")
    
    print(f"\n✓ Ways to decode: {dp[n]}")
    return dp[n]

# ============================================================================
# LONGEST INCREASING SUBSEQUENCE (LIS)
# ============================================================================

def longest_increasing_subsequence(nums):
    """
    LIS: Longest strictly increasing subsequence
    dp[i] = length of LIS ending at index i
    dp[i] = max(dp[j] + 1) for j < i where nums[j] < nums[i]
    """
    print(f"\n📈 Longest Increasing Subsequence")
    print(f"   Array: {nums}")
    
    if not nums:
        return 0
    
    n = len(nums)
    dp = [1] * n  # Each element is LIS of length 1
    
    for i in range(1, n):
        for j in range(i):
            if nums[j] < nums[i]:
                dp[i] = max(dp[i], dp[j] + 1)
        print(f"   dp[{i}] = {dp[i]} (LIS ending at index {i})")
    
    result = max(dp)
    print(f"\n✓ Length of LIS: {result}")
    return result

# ============================================================================
# PALINDROME PARTITIONING (MINIMUM CUTS)
# ============================================================================

def min_palindrome_cuts(s):
    """
    Minimum cuts to partition string into palindromes
    dp[i] = minimum cuts for string[0:i]
    """
    print(f"\n✂️ Minimum Palindrome Cuts")
    print(f"   String: {s}")
    
    n = len(s)
    dp = [0] * (n + 1)
    
    # Precompute palindrome table
    is_palindrome = [[False] * n for _ in range(n)]
    for i in range(n):
        is_palindrome[i][i] = True
    for i in range(n - 1):
        is_palindrome[i][i + 1] = (s[i] == s[i + 1])
    for length in range(3, n + 1):
        for i in range(n - length + 1):
            j = i + length - 1
            is_palindrome[i][j] = (s[i] == s[j] and is_palindrome[i + 1][j - 1])
    
    # DP
    for i in range(1, n + 1):
        dp[i] = i - 1  # Worst case: cut after each character
        for j in range(i):
            if is_palindrome[j][i - 1]:
                dp[i] = min(dp[i], dp[j] + 1)
        print(f"   dp[{i}] = {dp[i]}")
    
    print(f"\n✓ Minimum cuts: {dp[n]}")
    return dp[n]

# ============================================================================
# EXAMPLE 1: House Robber
# ============================================================================

print("=" * 70)
print("Example 1: House Robber")
print("=" * 70)

houses1 = [2, 7, 9, 3, 1]
house_robber(houses1)

# ============================================================================
# EXAMPLE 2: Coin Change
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Coin Change")
print("=" * 70)

coins1 = [1, 3, 4]
amount1 = 6
coin_change_min(coins1, amount1)

# ============================================================================
# EXAMPLE 3: Decode Ways
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Decode Ways")
print("=" * 70)

decode_ways("226")

# ============================================================================
# EXAMPLE 4: LIS
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Longest Increasing Subsequence")
print("=" * 70)

nums1 = [10, 9, 2, 5, 3, 7, 101, 18]
longest_increasing_subsequence(nums1)

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Problem':<30} {'Time':<20} {'Space':<20}")
print("─" * 70)
print(f"{'House Robber':<30} {'O(n)':<20} {'O(n) or O(1)'}")
print(f"{'Coin Change (min)':<30} {'O(amount × coins)':<20} {'O(amount)'}")
print(f"{'Coin Change (ways)':<30} {'O(amount × coins)':<20} {'O(amount)'}")
print(f"{'Decode Ways':<30} {'O(n)':<20} {'O(n)'}")
print(f"{'LIS':<30} {'O(n²)':<20} {'O(n)'}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ 1D DP uses single array dp[i]")
print("✓ State: dp[i] = answer for subproblem ending/up to index i")
print("✓ Transition: dp[i] depends on previous dp[j] values")
print("✓ Common patterns: max/min, sum, count")
print("✓ House Robber: max(rob current, skip current)")
print("✓ Coin Change: min/sum over all coin choices")
print("✓ Space can often be optimized to O(1) if only need previous values")
