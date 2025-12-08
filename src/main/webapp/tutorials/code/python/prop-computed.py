# Computed Properties

print("=== Computed Properties ===\n")

# 1. Derived values as properties
print("1. Properties computed from other attributes:")

class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    @property
    def area(self):
        """Computed: width * height."""
        return self.width * self.height

    @property
    def perimeter(self):
        """Computed: 2 * (width + height)."""
        return 2 * (self.width + self.height)

    @property
    def is_square(self):
        """Computed: check if square."""
        return self.width == self.height

rect = Rectangle(4, 5)
print(f"   Rectangle: {rect.width} x {rect.height}")
print(f"   Area: {rect.area}")
print(f"   Perimeter: {rect.perimeter}")
print(f"   Is square? {rect.is_square}")

# Properties update when source changes
rect.width = 5
print(f"   After width=5: Area={rect.area}, Is square? {rect.is_square}")
print()

# 2. Converting between units
print("2. Unit conversion properties:")

class Temperature:
    def __init__(self, celsius):
        self._celsius = celsius

    @property
    def celsius(self):
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        self._celsius = value

    @property
    def fahrenheit(self):
        """Convert celsius to fahrenheit."""
        return self._celsius * 9/5 + 32

    @fahrenheit.setter
    def fahrenheit(self, value):
        """Set via fahrenheit, store as celsius."""
        self._celsius = (value - 32) * 5/9

    @property
    def kelvin(self):
        """Convert celsius to kelvin."""
        return self._celsius + 273.15

temp = Temperature(0)
print(f"   0°C = {temp.fahrenheit}°F = {temp.kelvin}K")

temp.fahrenheit = 212  # Set via fahrenheit
print(f"   212°F = {temp.celsius}°C = {temp.kelvin}K")
print()

# 3. Formatted output properties
print("3. Formatting properties:")

class Product:
    def __init__(self, name, price_cents):
        self.name = name
        self._price_cents = price_cents

    @property
    def price(self):
        """Return price in dollars."""
        return self._price_cents / 100

    @property
    def price_display(self):
        """Formatted price string."""
        return f"${self.price:.2f}"

    @property
    def price_cents(self):
        return self._price_cents

product = Product("Widget", 1999)  # $19.99
print(f"   {product.name}: {product.price_display}")
print(f"   Raw cents: {product.price_cents}")
print()

# 4. Cached/lazy computed properties
print("4. Lazy evaluation (computed once):")

class DataAnalyzer:
    def __init__(self, data):
        self.data = data
        self._mean = None  # Cache

    @property
    def mean(self):
        """Compute mean only once, then cache."""
        if self._mean is None:
            print("   (Computing mean...)")
            self._mean = sum(self.data) / len(self.data)
        return self._mean

analyzer = DataAnalyzer([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
print(f"   First access: {analyzer.mean}")   # Computes
print(f"   Second access: {analyzer.mean}")  # Uses cache
print()

# 5. Using functools.cached_property (Python 3.8+)
print("5. @cached_property (Python 3.8+):")
print("""
   from functools import cached_property

   class DataAnalyzer:
       @cached_property
       def mean(self):
           # Computed only once, automatically cached
           return sum(self.data) / len(self.data)
""")
