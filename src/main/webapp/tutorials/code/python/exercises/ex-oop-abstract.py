# Exercise: Abstract Classes
# Task: Create an abstract class 'Shape' with an abstract method 'area'.

from abc import ABC, abstractmethod

# 1. Define Shape class inheriting from ABC
class Shape(ABC):
    # 2. Define abstract method area
    # Your code here:
    pass

# 3. Create a Square class inheriting from Shape
class Square(Shape):
    def __init__(self, side):
        self.side = side

    # 4. Implement area method
    def area(self):
        return self.side * self.side

s = Square(4)
print(s.area())
