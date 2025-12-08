# Comparing Different Types

# Numbers: int and float can be compared
print("5 == 5.0:", 5 == 5.0)     # True
print("5 > 4.9:", 5 > 4.9)       # True
print("3.14 < 4:", 3.14 < 4)     # True

print()

# Strings can be compared with ==
print('"hello" == "hello":', "hello" == "hello")  # True
print('"hello" == "Hello":', "hello" == "Hello")  # False (case matters!)

print()

# Numbers and strings are NOT equal
print('5 == "5":', 5 == "5")     # False (different types)
print('0 == "":', 0 == "")       # False

print()

# Boolean comparisons
print("True == 1:", True == 1)   # True (True is treated as 1)
print("False == 0:", False == 0) # True (False is treated as 0)
print("True > False:", True > False)  # True

# Note: Comparing strings with > or < uses Unicode order
# print(5 > "3")  # This would raise TypeError!
