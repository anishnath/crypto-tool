
a = (1, 2, 3, 4, 5)

# Standard sum
x = sum(a)
print(f"sum{a} = {x}")

# Sum with start value
# sum will satisfy: sum(iterable) + start
y = sum(a, 7)
print(f"sum{a} starting at 7 = {y}")

# Summing booleans
b = [True, False, True]
print(f"Sum of booleans (True=1, False=0): {sum(b)}")
