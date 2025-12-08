# Chained Comparisons - A Python specialty!

x = 5

# Traditional way (other languages)
print("x > 1 and x < 10:", x > 1 and x < 10)  # True

# Python's chained comparison (cleaner!)
print("1 < x < 10:", 1 < x < 10)              # True

print()

# More examples
age = 25
print("18 <= age <= 65:", 18 <= age <= 65)    # True (working age)

score = 85
print("80 <= score < 90:", 80 <= score < 90)  # True (B grade)

print()

# Multiple chains
a, b, c = 1, 2, 3
print("a < b < c:", a < b < c)                # True
print("a < b > c:", a < b > c)                # False (2 is not > 3)

# Even longer chains work!
print("0 < 1 < 2 < 3 < 4:", 0 < 1 < 2 < 3 < 4)  # True

print()

# Practical example: temperature range
temp = 72
if 60 <= temp <= 80:
    print(f"{temp}°F is comfortable")
else:
    print(f"{temp}°F is outside comfort range")
