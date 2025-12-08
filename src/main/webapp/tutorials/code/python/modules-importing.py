# Different Ways to Import Modules

# 1. Import entire module
print("=== Import Entire Module ===")
import math

print(f"math.sqrt(16) = {math.sqrt(16)}")
print(f"math.pi = {math.pi}")
print(f"math.ceil(4.2) = {math.ceil(4.2)}")
print()

# 2. Import specific items
print("=== Import Specific Items ===")
from random import randint, choice

# No need for random. prefix
print(f"randint(1, 10) = {randint(1, 10)}")
print(f"choice(['a', 'b', 'c']) = {choice(['a', 'b', 'c'])}")
print()

# 3. Import with alias
print("=== Import with Alias ===")
import datetime as dt
from collections import Counter as C

now = dt.datetime.now()
print(f"Current time: {now}")

words = C("mississippi")
print(f"Letter counts: {dict(words)}")
print()

# 4. Import all (use sparingly!)
print("=== Import All (*) ===")
from string import *  # Imports ascii_letters, digits, etc.

print(f"ascii_lowercase: {ascii_lowercase}")
print(f"digits: {digits}")
# Warning: This can cause name conflicts!
print()

# 5. Check what's available in a module
print("=== Exploring Modules ===")
import os

# dir() shows all attributes and methods
print("os module has", len(dir(os)), "attributes")
print("First 5:", dir(os)[:5])

# help() shows documentation (commented out - very long output)
# help(os.path.join)
