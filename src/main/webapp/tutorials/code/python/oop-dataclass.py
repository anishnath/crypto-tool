# Python Dataclasses
# Dataclasses are a way of creating classes that are primarily used to store data.
# They automatically generate methods like __init__, __repr__, __eq__, etc.

from dataclasses import dataclass

@dataclass
class Product:
    name: str
    price: float
    quantity: int = 0

    def total_cost(self) -> float:
        return self.price * self.quantity

# 1. Automatic __init__
p1 = Product("Laptop", 1000.0, 2)
p2 = Product("Laptop", 1000.0, 2)
p3 = Product("Mouse", 50.0, 5)

# 2. Automatic __repr__
print(p1)

# 3. Automatic __eq__
print(p1 == p2) # True
print(p1 == p3) # False

# 4. Custom methods work as usual
print(p1.total_cost())

# 5. Immutable Dataclass (frozen=True)
@dataclass(frozen=True)
class Point:
    x: int
    y: int

pt = Point(1, 2)
# pt.x = 5 # This will raise FrozenInstanceError
