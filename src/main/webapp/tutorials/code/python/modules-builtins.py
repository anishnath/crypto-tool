# Common Built-in Modules

# 1. os - Operating System Interface
print("=== os Module ===")
import os

print(f"Current directory: {os.getcwd()}")
print(f"Home directory: {os.path.expanduser('~')}")
print(f"Path separator: {os.sep}")
print(f"Environment PATH exists: {'PATH' in os.environ}")
print()

# 2. sys - System-specific Parameters
print("=== sys Module ===")
import sys

print(f"Python version: {sys.version_info.major}.{sys.version_info.minor}")
print(f"Platform: {sys.platform}")
print(f"Path to Python: {sys.executable}")
print()

# 3. random - Random Number Generation
print("=== random Module ===")
import random

print(f"Random int 1-10: {random.randint(1, 10)}")
print(f"Random float 0-1: {random.random():.4f}")
print(f"Random choice: {random.choice(['a', 'b', 'c'])}")
items = [1, 2, 3, 4, 5]
random.shuffle(items)
print(f"Shuffled: {items}")
print()

# 4. collections - Specialized Containers
print("=== collections Module ===")
from collections import Counter, defaultdict, namedtuple

# Counter
counts = Counter("mississippi")
print(f"Letter counts: {counts.most_common(3)}")

# defaultdict
dd = defaultdict(list)
dd["fruits"].append("apple")
dd["fruits"].append("banana")
print(f"Defaultdict: {dict(dd)}")

# namedtuple
Point = namedtuple("Point", ["x", "y"])
p = Point(3, 4)
print(f"Named tuple: {p}, x={p.x}, y={p.y}")
print()

# 5. itertools - Iterator Tools
print("=== itertools Module ===")
from itertools import count, cycle, chain

# chain combines iterables
combined = list(chain([1, 2], [3, 4], [5, 6]))
print(f"Chained: {combined}")

# count starts from n, increments
counter = count(start=10, step=2)
print(f"Count: {next(counter)}, {next(counter)}, {next(counter)}")
