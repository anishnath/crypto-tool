# Python Abstract Classes
# Abstract classes are classes that contain one or more abstract methods.
# An abstract method is a method that is declared, but contains no implementation.
# Abstract classes cannot be instantiated, and require subclasses to provide implementations for the abstract methods.

from abc import ABC, abstractmethod

class Polygon(ABC):

    @abstractmethod
    def noofsides(self):
        pass

class Triangle(Polygon):
    # overriding abstract method
    def noofsides(self):
        print("I have 3 sides")

class Pentagon(Polygon):
    # overriding abstract method
    def noofsides(self):
        print("I have 5 sides")

class Hexagon(Polygon):
    # overriding abstract method
    def noofsides(self):
        print("I have 6 sides")

# Driver code
R = Triangle()
R.noofsides()

K = Pentagon()
K.noofsides()

R = Hexagon()
R.noofsides()

# P = Polygon() # This will raise TypeError
