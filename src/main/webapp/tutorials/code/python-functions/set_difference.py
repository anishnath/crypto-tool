
x = {"apple", "banana", "cherry"}
y = {"google", "microsoft", "apple"}

# Return items that exist in x but not in y
z = x.difference(y)

print(f"X difference Y: {z}")

# Return items that exist in y but not in x
w = y.difference(x)
print(f"Y difference X: {w}")
