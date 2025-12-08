# Multiple Assignment in Python

# Assign same value to multiple variables
x = y = z = 0
print(f"x = {x}, y = {y}, z = {z}")

# Assign multiple values in one line
a, b, c = 1, 2, 3
print(f"a = {a}, b = {b}, c = {c}")

# Swap values without temp variable
print("\nBefore swap: a =", a, ", b =", b)
a, b = b, a
print("After swap:  a =", a, ", b =", b)

# Unpack a list into variables
coordinates = [10, 20, 30]
x, y, z = coordinates
print(f"\nUnpacked: x = {x}, y = {y}, z = {z}")

# Unpack with * (rest operator)
first, *rest = [1, 2, 3, 4, 5]
print(f"\nfirst = {first}")
print(f"rest = {rest}")

# Unpack middle
first, *middle, last = [1, 2, 3, 4, 5]
print(f"\nfirst = {first}, middle = {middle}, last = {last}")
