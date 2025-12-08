# Python Modules
# A module is a file containing a set of functions you want to include in your application.

# 1. Importing a Built-in Module
import platform

system = platform.system()
print(f"System: {system}")

# 2. Importing Specific Functions
from math import sqrt, pi

print(f"Square root of 16: {sqrt(16)}")
print(f"Pi: {pi}")

# 3. Aliasing Modules
import datetime as dt

now = dt.datetime.now()
print(f"Current time: {now}")

# 4. Listing Module Contents
import math
print("\nMath module contents:")
# print(dir(math)) # Uncomment to see full list (it's long!)
print(dir(math)[:5]) # Printing first 5 items for brevity
