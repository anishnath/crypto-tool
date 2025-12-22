# O(2ⁿ) - Exponential Time Example
# Fibonacci with naive recursion - VERY SLOW!

call_count = 0

def fibonacci_recursive(n):
    """Naive recursive Fibonacci - exponential time!"""
    global call_count
    call_count += 1
    
    if n <= 1:
        return n
    
    return fibonacci_recursive(n - 1) + fibonacci_recursive(n - 2)

def fibonacci_optimized(n, memo={}):
    """Optimized with memoization - much faster!"""
    if n in memo:
        return memo[n]
    
    if n <= 1:
        return n
    
    memo[n] = fibonacci_optimized(n - 1, memo) + fibonacci_optimized(n - 2, memo)
    return memo[n]

# Test
print("O(2ⁿ) - Exponential Time")
print("=" * 40)

# Small input - already slow!
n = 10
call_count = 0
result = fibonacci_recursive(n)
print(f"Fibonacci({n}) = {result}")
print(f"Function calls: {call_count}")
print(f"Expected ~2^{n} = {2**n} operations\n")

# Larger input
n = 20
call_count = 0
result = fibonacci_recursive(n)
print(f"Fibonacci({n}) = {result}")
print(f"Function calls: {call_count}")
print(f"Expected ~2^{n} = {2**n:,} operations\n")

print("⚠️ WARNING: Don't try n=30+ with naive recursion!")
print("It would take millions of operations!\n")

# Show optimized version
print("With optimization (memoization):")
result = fibonacci_optimized(50)
print(f"Fibonacci(50) = {result}")
print("✅ Runs instantly!\n")

print("✅ Time complexity: O(2ⁿ)")
print("This is why algorithm choice matters!")
