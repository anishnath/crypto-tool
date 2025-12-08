# Polymorphism Through Inheritance

print("=== Inheritance Polymorphism ===\n")

# 1. Method overriding for polymorphism
print("1. Base class with common interface:")

class Shape:
    """Base class defining the interface."""

    def area(self):
        raise NotImplementedError("Subclass must implement")

    def perimeter(self):
        raise NotImplementedError("Subclass must implement")

    def describe(self):
        return f"{self.__class__.__name__}: area={self.area():.2f}"


class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def perimeter(self):
        return 2 * (self.width + self.height)


class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        import math
        return math.pi * self.radius ** 2

    def perimeter(self):
        import math
        return 2 * math.pi * self.radius


class Triangle(Shape):
    def __init__(self, base, height, side1, side2, side3):
        self.base = base
        self.height = height
        self.sides = (side1, side2, side3)

    def area(self):
        return 0.5 * self.base * self.height

    def perimeter(self):
        return sum(self.sides)


# Polymorphism in action - same code, different behaviors
shapes = [Rectangle(4, 5), Circle(3), Triangle(6, 4, 5, 5, 6)]

for shape in shapes:
    print(f"   {shape.describe()}")
print()

# 2. Polymorphism enables generic functions
print("2. Generic function using polymorphism:")

def total_area(shapes):
    """Calculate total area of any shape objects."""
    return sum(shape.area() for shape in shapes)

def largest_shape(shapes):
    """Find shape with largest area."""
    return max(shapes, key=lambda s: s.area())

print(f"   Total area: {total_area(shapes):.2f}")
print(f"   Largest: {largest_shape(shapes).describe()}")
print()

# 3. Extending with new shapes - no code changes needed
print("3. Adding new shapes (Open/Closed Principle):")

class Square(Rectangle):
    """Square is just a special rectangle."""
    def __init__(self, side):
        super().__init__(side, side)

class Ellipse(Shape):
    """New shape - existing code still works!"""
    def __init__(self, a, b):
        self.a = a  # semi-major axis
        self.b = b  # semi-minor axis

    def area(self):
        import math
        return math.pi * self.a * self.b

    def perimeter(self):
        # Approximation
        import math
        return math.pi * (3 * (self.a + self.b) -
                         ((3*self.a + self.b) * (self.a + 3*self.b)) ** 0.5)

# Add new shapes - existing functions still work!
all_shapes = shapes + [Square(4), Ellipse(3, 2)]

print(f"   Total area (with new shapes): {total_area(all_shapes):.2f}")
print()

# 4. Practical example: Payment processing
print("4. Practical example - Payment System:")

class PaymentMethod:
    def process(self, amount):
        raise NotImplementedError

    def get_name(self):
        return self.__class__.__name__

class CreditCard(PaymentMethod):
    def __init__(self, card_number):
        self.card_number = card_number

    def process(self, amount):
        return f"Charged ${amount} to card ****{self.card_number[-4:]}"

class PayPal(PaymentMethod):
    def __init__(self, email):
        self.email = email

    def process(self, amount):
        return f"PayPal payment of ${amount} from {self.email}"

class Crypto(PaymentMethod):
    def __init__(self, wallet):
        self.wallet = wallet

    def process(self, amount):
        return f"Crypto transfer of ${amount} to {self.wallet[:8]}..."

def checkout(payment_method, amount):
    """Works with ANY payment method!"""
    print(f"   Processing with {payment_method.get_name()}:")
    print(f"   {payment_method.process(amount)}")

checkout(CreditCard("1234567890123456"), 99.99)
checkout(PayPal("user@example.com"), 49.99)
checkout(Crypto("0x742d35Cc6634C0532925a3b844Bc9e7595f"), 199.99)
