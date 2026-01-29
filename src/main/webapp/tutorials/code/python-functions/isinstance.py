
# Basic checks
x = 5
print(f"Is {x} an integer?", isinstance(x, int))

y = "Hello"
print(f"Is '{y}' a string?", isinstance(y, str))

# Checking against a tuple of types
z = [1, 2, 3]
print(f"Is {z} a list or tuple?", isinstance(z, (list, tuple)))

class A:
    pass

class B(A):
    pass

obj = B()
print("Is obj instance of B?", isinstance(obj, B))
print("Is obj instance of A?", isinstance(obj, A))
