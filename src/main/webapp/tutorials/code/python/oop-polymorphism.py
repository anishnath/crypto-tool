# Python Polymorphism
# The word "polymorphism" means "many forms", and in programming it refers to methods/functions/operators with the same name that can be executed on many objects or classes.

# 1. Class Polymorphism
class Car:
    def __init__(self, brand, model):
        self.brand = brand
        self.model = model

    def move(self):
        print("Drive!")

class Boat:
    def __init__(self, brand, model):
        self.brand = brand
        self.model = model

    def move(self):
        print("Sail!")

class Plane:
    def __init__(self, brand, model):
        self.brand = brand
        self.model = model

    def move(self):
        print("Fly!")

car1 = Car("Ford", "Mustang")
boat1 = Boat("Ibiza", "Touring 20")
plane1 = Plane("Boeing", "747")

for x in (car1, boat1, plane1):
    x.move()

# 2. Inheritance Class Polymorphism (Method Overriding)
class Vehicle:
    def __init__(self, brand, model):
        self.brand = brand
        self.model = model

    def move(self):
        print("Move!")

class CarV(Vehicle):
    pass

class BoatV(Vehicle):
    def move(self):
        print("Sail!")

class PlaneV(Vehicle):
    def move(self):
        print("Fly!")

car2 = CarV("Ford", "Mustang")
boat2 = BoatV("Ibiza", "Touring 20")
plane2 = PlaneV("Boeing", "747")

for x in (car2, boat2, plane2):
    print(x.brand)
    x.move()
