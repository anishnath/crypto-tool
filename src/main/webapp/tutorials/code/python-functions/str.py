
# Integer to string
x = str(123)
print(f"str(123) type: {type(x)}, value: {x}")

# Float to string
y = str(3.14)
print(f"str(3.14) type: {type(y)}, value: {y}")

# List to string
z = str([1, 2, 3])
print(f"str([1, 2, 3]) value: {z}")

# Encoding example (bytes to string)
b = b'\xe2\x82\xac'
s = str(b, encoding='utf-8')
print(f"Decoded bytes: {s}")
