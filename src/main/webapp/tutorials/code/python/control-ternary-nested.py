# Nested Ternary Operators (Use with Caution!)

# Simple nested ternary for grades
score = 85

# This works but gets hard to read...
grade = "A" if score >= 90 else "B" if score >= 80 else "C" if score >= 70 else "F"
print(f"Score {score}: Grade {grade}")

print()

# Breaking down the nested ternary:
print("=== How Nested Ternary Works ===")
print("grade = 'A' if score >= 90 else ('B' if score >= 80 else ('C' if score >= 70 else 'F'))")
print()
print("Read it as:")
print("  if score >= 90:      return 'A'")
print("  elif score >= 80:    return 'B'")
print("  elif score >= 70:    return 'C'")
print("  else:                return 'F'")

print()

# Chained ternary for three options
print("=== Three Options ===")
x = 0
sign = "positive" if x > 0 else "negative" if x < 0 else "zero"
print(f"{x} is {sign}")

x = 5
sign = "positive" if x > 0 else "negative" if x < 0 else "zero"
print(f"{x} is {sign}")

x = -3
sign = "positive" if x > 0 else "negative" if x < 0 else "zero"
print(f"{x} is {sign}")

print()

# When NOT to use nested ternary
print("=== Better Alternative: if-elif-else ===")
# This is more readable for complex logic:
score = 75
if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
else:
    grade = "F"
print(f"Score {score}: Grade {grade}")
