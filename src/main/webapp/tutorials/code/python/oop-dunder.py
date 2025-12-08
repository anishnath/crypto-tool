# Python Special Methods (Dunder Methods)
# Special methods are a set of predefined methods you can use to enrich your classes.
# They start and end with double underscores, for example __init__ or __str__.

class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    # String representation for end-users
    def __str__(self):
        return f"Vector({self.x}, {self.y})"

    # String representation for developers (debugging)
    def __repr__(self):
        return f"Vector(x={self.x}, y={self.y})"

    # Length behavior
    def __len__(self):
        return int((self.x**2 + self.y**2) ** 0.5)

    # Addition behavior (+)
    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)

    # Equality behavior (==)
    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

v1 = Vector(2, 3)
v2 = Vector(2, 3)
v3 = Vector(5, 7)

print(str(v1))      # Calls __str__
print(repr(v1))     # Calls __repr__
print(len(v1))      # Calls __len__ (approx length)
print(v1 == v2)     # Calls __eq__ -> True
print(v1 == v3)     # Calls __eq__ -> False

v4 = v1 + v3        # Calls __add__
print(v4)
