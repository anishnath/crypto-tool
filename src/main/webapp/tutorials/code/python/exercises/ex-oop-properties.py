# Exercise: Properties
# Task: Use @property to create a getter for 'radius'.

class Circle:
    def __init__(self, radius):
        self._radius = radius

    # 1. Create a property 'radius' that returns _radius
    # Your code here:


c = Circle(5)
print(c.radius)
