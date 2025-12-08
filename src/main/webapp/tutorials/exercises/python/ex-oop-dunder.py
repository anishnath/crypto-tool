# Exercise: Fraction Class
# Create a Fraction class with dunder methods for arithmetic and comparison

class Fraction:
    """
    Represent a fraction with numerator and denominator.
    Implement the following dunder methods:
    """

    def __init__(self, numerator, denominator):
        # Store numerator and denominator
        # Hint: You might want to simplify the fraction
        # Your code here:
        pass

    # 1. __str__ - Return "numerator/denominator" (e.g., "3/4")
    # Your code here:


    # 2. __repr__ - Return "Fraction(numerator, denominator)"
    # Your code here:


    # 3. __eq__ - Check if two fractions are equal (1/2 == 2/4)
    # Your code here:


    # 4. __lt__ - Compare fractions (for sorting)
    # Your code here:


    # 5. __add__ - Add two fractions
    #    Formula: a/b + c/d = (a*d + c*b) / (b*d)
    # Your code here:


    # 6. __mul__ - Multiply two fractions
    #    Formula: a/b * c/d = (a*c) / (b*d)
    # Your code here:


    # Helper method to simplify fractions (optional but recommended)
    # Use greatest common divisor (gcd)
    @staticmethod
    def _gcd(a, b):
        while b:
            a, b = b, a % b
        return a


# Test your implementation:

# f1 = Fraction(1, 2)
# f2 = Fraction(1, 4)
# f3 = Fraction(2, 4)  # Should equal f1

# print(f"str(f1): {f1}")  # 1/2
# print(f"repr(f1): {repr(f1)}")  # Fraction(1, 2)

# print(f"f1 == f3: {f1 == f3}")  # True (1/2 == 2/4)
# print(f"f1 < f3: {f1 < f3}")  # False

# print(f"f1 + f2: {f1 + f2}")  # 3/4
# print(f"f1 * f2: {f1 * f2}")  # 1/8

# Test sorting
# fractions = [Fraction(3, 4), Fraction(1, 2), Fraction(1, 4)]
# print(f"Sorted: {sorted(fractions)}")  # [1/4, 1/2, 3/4]
