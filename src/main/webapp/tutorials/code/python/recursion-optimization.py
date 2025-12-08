# Recursion Optimization and Limits

import sys

# 1. The recursion limit
print("=== Recursion Limit ===")
print(f"Default recursion limit: {sys.getrecursionlimit()}")
# sys.setrecursionlimit(2000)  # Can increase if needed
print()

# 2. Problem: Naive Fibonacci is slow
print("=== Slow Fibonacci ===")
call_count = 0

def fib_slow(n):
    """Slow recursive Fibonacci."""
    global call_count
    call_count += 1
    if n <= 1:
        return n
    return fib_slow(n - 1) + fib_slow(n - 2)

call_count = 0
result = fib_slow(20)
print(f"fib(20) = {result}")
print(f"Function calls: {call_count}")  # Many redundant calls!
print()

# 3. Solution: Memoization
print("=== Memoized Fibonacci ===")
def fib_memo(n, cache={}):
    """Fibonacci with memoization."""
    if n in cache:
        return cache[n]
    if n <= 1:
        return n
    cache[n] = fib_memo(n - 1, cache) + fib_memo(n - 2, cache)
    return cache[n]

print(f"fib_memo(50) = {fib_memo(50)}")  # Fast now!
print()

# 4. Using functools.lru_cache
print("=== Using @lru_cache ===")
from functools import lru_cache

@lru_cache(maxsize=None)
def fib_cached(n):
    """Fibonacci with automatic caching."""
    if n <= 1:
        return n
    return fib_cached(n - 1) + fib_cached(n - 2)

print(f"fib_cached(100) = {fib_cached(100)}")
print(f"Cache info: {fib_cached.cache_info()}")
print()

# 5. Iterative alternative (often better)
print("=== Iterative Alternative ===")
def fib_iterative(n):
    """Fibonacci using iteration - no recursion depth issues."""
    if n <= 1:
        return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b

print(f"fib_iterative(100) = {fib_iterative(100)}")
print("No recursion = no stack overflow risk")
