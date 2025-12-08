# Order of Operations (PEMDAS)

# Without parentheses - follows PEMDAS
result1 = 2 + 3 * 4      # 2 + 12 = 14 (multiplication first)
result2 = 10 - 6 / 2     # 10 - 3.0 = 7.0 (division first)
result3 = 2 ** 3 * 4     # 8 * 4 = 32 (exponent first)

print("2 + 3 * 4 =", result1)
print("10 - 6 / 2 =", result2)
print("2 ** 3 * 4 =", result3)

print()

# With parentheses - override default order
result4 = (2 + 3) * 4    # 5 * 4 = 20
result5 = (10 - 6) / 2   # 4 / 2 = 2.0
result6 = 2 ** (3 * 4)   # 2^12 = 4096

print("(2 + 3) * 4 =", result4)
print("(10 - 6) / 2 =", result5)
print("2 ** (3 * 4) =", result6)

print()

# Complex expression
# Calculate: (10 + 5) * 2 - 3^2 / 3
complex_result = (10 + 5) * 2 - 3**2 / 3
print("(10 + 5) * 2 - 3**2 / 3 =", complex_result)  # 30 - 3 = 27.0
