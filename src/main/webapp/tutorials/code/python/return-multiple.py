# Returning Multiple Values

# 1. Return tuple (most common)
print("=== Return Tuple ===")
def get_min_max(numbers):
    """Return both minimum and maximum."""
    return min(numbers), max(numbers)

result = get_min_max([3, 1, 4, 1, 5, 9])
print(f"Result: {result}")
print(f"Type: {type(result)}")

# Unpack into variables
min_val, max_val = get_min_max([3, 1, 4, 1, 5, 9])
print(f"Min: {min_val}, Max: {max_val}")
print()

# 2. Return dictionary for named values
print("=== Return Dictionary ===")
def analyze_text(text):
    """Analyze text and return statistics."""
    words = text.split()
    return {
        "char_count": len(text),
        "word_count": len(words),
        "avg_word_length": len(text.replace(" ", "")) / len(words) if words else 0
    }

stats = analyze_text("Hello World")
print(f"Stats: {stats}")
print(f"Word count: {stats['word_count']}")
print()

# 3. Return list when order matters
print("=== Return List ===")
def get_factors(n):
    """Return all factors of n."""
    return [i for i in range(1, n + 1) if n % i == 0]

factors = get_factors(12)
print(f"Factors of 12: {factors}")
print()

# 4. Return named tuple (best of both)
print("=== Return Named Tuple ===")
from collections import namedtuple

Point = namedtuple("Point", ["x", "y"])

def create_point(x, y):
    """Create a point with named attributes."""
    return Point(x, y)

p = create_point(3, 4)
print(f"Point: {p}")
print(f"X: {p.x}, Y: {p.y}")
print(f"Can also unpack: x={p[0]}, y={p[1]}")
