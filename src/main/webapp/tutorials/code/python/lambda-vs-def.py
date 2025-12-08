# Lambda vs def - When to Use Which

# 1. Readability comparison
print("=== Readability ===")

# Lambda: concise for simple operations
nums = [1, 2, 3, 4, 5]
squares = list(map(lambda x: x**2, nums))
print(f"Lambda map: {squares}")

# def: better for anything complex
def calculate_square(x):
    """Return the square of x."""
    return x ** 2

squares = list(map(calculate_square, nums))
print(f"def map: {squares}")
print()

# 2. When lambda is appropriate
print("=== Good Lambda Use Cases ===")

# Short sorting keys
students = [("Alice", 88), ("Bob", 95), ("Charlie", 72)]
sorted_students = sorted(students, key=lambda s: s[1])
print(f"Sorted by grade: {sorted_students}")

# Quick filter conditions
words = ["apple", "pie", "elephant", "hi"]
long_words = list(filter(lambda w: len(w) > 3, words))
print(f"Long words: {long_words}")

# Simple transformations
prices = [10, 20, 30]
with_tax = list(map(lambda p: p * 1.1, prices))
print(f"With tax: {with_tax}")
print()

# 3. When def is better
print("=== When def is Better ===")

# Multiple statements needed
def process_user(user):
    """Process user data with validation."""
    if not user.get("name"):
        return None
    if not user.get("email"):
        return None
    return {
        "name": user["name"].strip().title(),
        "email": user["email"].lower()
    }

user = {"name": "  alice  ", "email": "ALICE@EXAMPLE.COM"}
print(f"Processed: {process_user(user)}")

# Need docstring for documentation
def calculate_tax(amount, rate=0.1):
    """
    Calculate tax on an amount.

    Args:
        amount: The base amount
        rate: Tax rate (default 10%)

    Returns:
        The tax amount
    """
    return amount * rate

print(f"Tax: {calculate_tax(100)}")
print()

# 4. Comprehensions vs map/filter with lambda
print("=== Comprehensions Are Often Clearer ===")
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Lambda approach
result1 = list(map(lambda x: x**2, filter(lambda x: x % 2 == 0, numbers)))
print(f"Lambda: {result1}")

# Comprehension approach (preferred)
result2 = [x**2 for x in numbers if x % 2 == 0]
print(f"Comprehension: {result2}")

# Same result, but comprehension is more Pythonic
