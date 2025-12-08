# Complex Numbers in Python
# Numbers with real and imaginary parts

# Creating complex numbers
z1 = 3 + 4j          # Using j for imaginary unit
z2 = complex(2, -1)  # Using complex() function
z3 = 5j              # Pure imaginary

print("Complex numbers:")
print(f"z1 = {z1}")
print(f"z2 = {z2}")
print(f"z3 = {z3}")

# Accessing real and imaginary parts
print(f"\nParts of z1 ({z1}):")
print(f"Real part: {z1.real}")
print(f"Imaginary part: {z1.imag}")

# Complex arithmetic
print(f"\nArithmetic:")
print(f"z1 + z2 = {z1 + z2}")
print(f"z1 - z2 = {z1 - z2}")
print(f"z1 * z2 = {z1 * z2}")
print(f"z1 / z2 = {z1 / z2}")

# Conjugate (flip sign of imaginary part)
print(f"\nConjugate of {z1} = {z1.conjugate()}")

# Absolute value (magnitude)
print(f"Magnitude of {z1} = {abs(z1)}")  # sqrt(3² + 4²) = 5

# Using cmath for complex math functions
import cmath
print(f"\nUsing cmath:")
print(f"Phase (angle): {cmath.phase(z1):.4f} radians")
print(f"Polar form: {cmath.polar(z1)}")
