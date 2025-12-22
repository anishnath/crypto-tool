"""
Knapsack Problems
0/1 Knapsack, Unbounded Knapsack, Subset Sum
"""

# ============================================================================
# 0/1 KNAPSACK
# ============================================================================

def knapsack_01(weights, values, capacity):
    """
    0/1 Knapsack: Each item can be taken at most once
    
    dp[i][w] = maximum value using first i items with capacity w
    dp[i][w] = max(
        dp[i-1][w],                    # Don't take item i
        dp[i-1][w-weights[i-1]] + values[i-1]  # Take item i
    )
    """
    print(f"\n🎒 0/1 Knapsack Problem")
    print(f"   Weights: {weights}")
    print(f"   Values: {values}")
    print(f"   Capacity: {capacity}")
    
    n = len(weights)
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]
    
    for i in range(1, n + 1):
        for w in range(capacity + 1):
            # Don't take item i-1
            dp[i][w] = dp[i - 1][w]
            
            # Take item i-1 (if weight allows)
            if w >= weights[i - 1]:
                take_value = dp[i - 1][w - weights[i - 1]] + values[i - 1]
                dp[i][w] = max(dp[i][w], take_value)
    
    print(f"\n✓ Maximum value: {dp[n][capacity]}")
    return dp[n][capacity]

def knapsack_01_optimized(weights, values, capacity):
    """Space-optimized: Only need previous row"""
    n = len(weights)
    dp = [0] * (capacity + 1)
    
    for i in range(n):
        # Traverse backwards to avoid overwriting needed values
        for w in range(capacity, weights[i] - 1, -1):
            dp[w] = max(dp[w], dp[w - weights[i]] + values[i])
    
    return dp[capacity]

# ============================================================================
# UNBOUNDED KNAPSACK
# ============================================================================

def knapsack_unbounded(weights, values, capacity):
    """
    Unbounded Knapsack: Each item can be taken unlimited times
    
    dp[w] = maximum value with capacity w
    dp[w] = max(dp[w-weight[i]] + value[i]) for all items i
    """
    print(f"\n🎒 Unbounded Knapsack Problem")
    print(f"   Weights: {weights}")
    print(f"   Values: {values}")
    print(f"   Capacity: {capacity}")
    
    dp = [0] * (capacity + 1)
    
    for w in range(1, capacity + 1):
        for i in range(len(weights)):
            if w >= weights[i]:
                dp[w] = max(dp[w], dp[w - weights[i]] + values[i])
    
    print(f"\n✓ Maximum value: {dp[capacity]}")
    return dp[capacity]

# ============================================================================
# SUBSET SUM
# ============================================================================

def subset_sum(nums, target):
    """
    Subset Sum: Can we form target sum using subset of nums?
    
    dp[i][s] = can we form sum s using first i numbers?
    dp[i][s] = dp[i-1][s] or dp[i-1][s-nums[i-1]]
    """
    print(f"\n✅ Subset Sum Problem")
    print(f"   Numbers: {nums}")
    print(f"   Target: {target}")
    
    n = len(nums)
    dp = [[False] * (target + 1) for _ in range(n + 1)]
    
    # Base case: sum 0 can always be formed (empty subset)
    for i in range(n + 1):
        dp[i][0] = True
    
    for i in range(1, n + 1):
        for s in range(1, target + 1):
            # Don't use nums[i-1]
            dp[i][s] = dp[i - 1][s]
            
            # Use nums[i-1]
            if s >= nums[i - 1]:
                dp[i][s] = dp[i][s] or dp[i - 1][s - nums[i - 1]]
    
    result = dp[n][target]
    print(f"\n✓ Can form target sum: {result}")
    return result

def subset_sum_optimized(nums, target):
    """Space-optimized subset sum"""
    dp = [False] * (target + 1)
    dp[0] = True
    
    for num in nums:
        for s in range(target, num - 1, -1):
            dp[s] = dp[s] or dp[s - num]
    
    return dp[target]

# ============================================================================
# PARTITION EQUAL SUBSET SUM
# ============================================================================

def can_partition(nums):
    """
    Partition Equal Subset Sum: Can partition array into two equal-sum subsets?
    This is subset sum with target = sum(nums) / 2
    """
    total = sum(nums)
    if total % 2 != 0:
        return False
    
    target = total // 2
    return subset_sum_optimized(nums, target)

# ============================================================================
# COIN CHANGE (KNAPSACK VARIANT)
# ============================================================================

def coin_change_knapsack(coins, amount):
    """
    Coin Change as Unbounded Knapsack
    Each coin can be used unlimited times
    Minimize number of coins
    """
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0
    
    for coin in coins:
        for i in range(coin, amount + 1):
            dp[i] = min(dp[i], dp[i - coin] + 1)
    
    return dp[amount] if dp[amount] != float('inf') else -1

# ============================================================================
# TARGET SUM
# ============================================================================

def target_sum(nums, target):
    """
    Target Sum: Assign + or - to each number to get target
    This reduces to subset sum problem
    """
    total = sum(nums)
    if (total + target) % 2 != 0 or total < abs(target):
        return 0
    
    # Find subset with sum = (total + target) / 2
    new_target = (total + target) // 2
    
    dp = [0] * (new_target + 1)
    dp[0] = 1
    
    for num in nums:
        for s in range(new_target, num - 1, -1):
            dp[s] += dp[s - num]
    
    return dp[new_target]

# ============================================================================
# EXAMPLE 1: 0/1 Knapsack
# ============================================================================

print("=" * 70)
print("Example 1: 0/1 Knapsack")
print("=" * 70)

weights1 = [1, 3, 4, 5]
values1 = [1, 4, 5, 7]
capacity1 = 7
knapsack_01(weights1, values1, capacity1)

# ============================================================================
# EXAMPLE 2: Unbounded Knapsack
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Unbounded Knapsack")
print("=" * 70)

weights2 = [1, 3, 4]
values2 = [10, 40, 50]
capacity2 = 8
knapsack_unbounded(weights2, values2, capacity2)

# ============================================================================
# EXAMPLE 3: Subset Sum
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Subset Sum")
print("=" * 70)

nums1 = [3, 34, 4, 12, 5, 2]
target1 = 9
subset_sum(nums1, target1)

# ============================================================================
# EXAMPLE 4: Partition Equal Subset Sum
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Partition Equal Subset Sum")
print("=" * 70)

nums2 = [1, 5, 11, 5]
print(f"   Numbers: {nums2}")
result = can_partition(nums2)
print(f"   Can partition equally: {result}")

# ============================================================================
# KNAPSACK PATTERNS
# ============================================================================

def knapsack_patterns():
    """
    Common knapsack problem patterns
    """
    print("\n" + "=" * 70)
    print("Knapsack Problem Patterns")
    print("=" * 70)
    
    print("\n📦 0/1 Knapsack:")
    print("   • Each item: take or don't take")
    print("   • dp[i][w] = max(don't take, take)")
    print("   • Loop backwards for space optimization")
    
    print("\n♾️ Unbounded Knapsack:")
    print("   • Items can be taken unlimited times")
    print("   • dp[w] = max over all items")
    print("   • Similar to coin change")
    
    print("\n✅ Subset Sum:")
    print("   • Boolean DP: can we form sum?")
    print("   • dp[i][s] = dp[i-1][s] OR dp[i-1][s-num]")
    
    print("\n💡 Key Insight:")
    print("   All knapsack problems share same structure:")
    print("   • State: capacity/weight constraint")
    print("   • Choice: include item or not")
    print("   • Transition: max/min over choices")

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Problem':<30} {'Time':<25} {'Space'}")
print("─" * 75)
print(f"{'0/1 Knapsack':<30} {'O(n × capacity)':<25} {'O(n × capacity)'}")
print(f"{'0/1 (optimized)':<30} {'O(n × capacity)':<25} {'O(capacity)'}")
print(f"{'Unbounded Knapsack':<30} {'O(n × capacity)':<25} {'O(capacity)'}")
print(f"{'Subset Sum':<30} {'O(n × target)':<25} {'O(target)'}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Knapsack = optimization with constraints")
print("✓ 0/1: Each item once, 2D DP")
print("✓ Unbounded: Items unlimited, 1D DP")
print("✓ Subset Sum: Boolean DP, can we form sum?")
print("✓ Key pattern: dp[i][w] = max(include item, exclude item)")
print("✓ Space optimization: Loop backwards for 0/1 knapsack")
print("✓ Coin change is essentially unbounded knapsack")

knapsack_patterns()
