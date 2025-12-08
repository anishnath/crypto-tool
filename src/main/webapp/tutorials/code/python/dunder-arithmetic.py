# Arithmetic Operators: __add__, __sub__, __mul__, etc.

print("=== Arithmetic Operators ===\n")

# 1. Basic arithmetic operators
print("1. Basic arithmetic (__add__, __sub__, __mul__):")

class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __add__(self, other):
        """v1 + v2"""
        return Vector(self.x + other.x, self.y + other.y)

    def __sub__(self, other):
        """v1 - v2"""
        return Vector(self.x - other.x, self.y - other.y)

    def __mul__(self, scalar):
        """v * 3 (scalar multiplication)"""
        return Vector(self.x * scalar, self.y * scalar)

    def __repr__(self):
        return f"Vector({self.x}, {self.y})"

v1 = Vector(3, 4)
v2 = Vector(1, 2)

print(f"   v1 + v2 = {v1 + v2}")
print(f"   v1 - v2 = {v1 - v2}")
print(f"   v1 * 3 = {v1 * 3}")
print()

# 2. Reverse operators (__radd__, __rmul__)
print("2. Reverse operators (3 * v instead of v * 3):")

class Vector2:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __mul__(self, scalar):
        """v * 3"""
        return Vector2(self.x * scalar, self.y * scalar)

    def __rmul__(self, scalar):
        """3 * v - called when left operand doesn't support *"""
        return self.__mul__(scalar)

    def __repr__(self):
        return f"Vector2({self.x}, {self.y})"

v = Vector2(2, 3)
print(f"   v * 5 = {v * 5}")
print(f"   5 * v = {5 * v}")  # Uses __rmul__
print()

# 3. In-place operators (__iadd__, __imul__)
print("3. In-place operators (+=, *=):")

class Counter:
    def __init__(self, value=0):
        self.value = value

    def __add__(self, other):
        """Creates new object"""
        return Counter(self.value + other)

    def __iadd__(self, other):
        """Modifies in place (optional but efficient)"""
        self.value += other
        return self  # Must return self!

    def __repr__(self):
        return f"Counter({self.value})"

c = Counter(10)
print(f"   Initial: {c}")
c += 5
print(f"   After += 5: {c}")
print()

# 4. Unary operators
print("4. Unary operators (__neg__, __abs__):")

class Temperature:
    def __init__(self, celsius):
        self.celsius = celsius

    def __neg__(self):
        """-temp (negative)"""
        return Temperature(-self.celsius)

    def __abs__(self):
        """abs(temp)"""
        return Temperature(abs(self.celsius))

    def __repr__(self):
        return f"Temperature({self.celsius}°C)"

t = Temperature(-15)
print(f"   t = {t}")
print(f"   -t = {-t}")
print(f"   abs(t) = {abs(t)}")
print()

# 5. Complete operator table
print("5. Common arithmetic methods:")
print("""
   Method        Operator    Example
   ------        --------    -------
   __add__       +           a + b
   __sub__       -           a - b
   __mul__       *           a * b
   __truediv__   /           a / b
   __floordiv__  //          a // b
   __mod__       %           a % b
   __pow__       **          a ** b

   __radd__      +           b + a (reverse)
   __iadd__      +=          a += b (in-place)

   __neg__       -           -a (unary)
   __pos__       +           +a
   __abs__       abs()       abs(a)
""")

# 6. Practical example: Money class
print("6. Practical example - Money class:")

class Money:
    def __init__(self, dollars, cents=0):
        self.cents = dollars * 100 + cents

    def __add__(self, other):
        return Money(0, self.cents + other.cents)

    def __sub__(self, other):
        return Money(0, self.cents - other.cents)

    def __mul__(self, factor):
        return Money(0, int(self.cents * factor))

    def __repr__(self):
        return f"${self.cents // 100}.{self.cents % 100:02d}"

price = Money(19, 99)
tax = Money(1, 60)
total = price + tax
discounted = total * 0.9

print(f"   Price: {price}")
print(f"   Tax: {tax}")
print(f"   Total: {total}")
print(f"   10% off: {discounted}")
