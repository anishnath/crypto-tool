# Division vs Floor Division

# Regular division (/) always returns a float
print("10 / 3 =", 10 / 3)     # 3.333...
print("10 / 2 =", 10 / 2)     # 5.0 (still a float!)
print("9 / 3 =", 9 / 3)       # 3.0

print()  # blank line

# Floor division (//) rounds DOWN to nearest integer
print("10 // 3 =", 10 // 3)   # 3
print("10 // 2 =", 10 // 2)   # 5
print("9 // 3 =", 9 // 3)     # 3

print()

# With floats, floor division still rounds down
print("10.0 // 3 =", 10.0 // 3)   # 3.0 (returns float)
print("7.5 // 2 =", 7.5 // 2)     # 3.0

print()

# Negative numbers - floor rounds toward NEGATIVE infinity!
print("-7 // 3 =", -7 // 3)   # -3 (not -2!)
print("7 // -3 =", 7 // -3)   # -3
