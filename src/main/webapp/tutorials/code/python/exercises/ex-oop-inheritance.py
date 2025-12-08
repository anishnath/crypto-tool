# Exercise: Inheritance
# Task: Create a child class 'ElectricCar' that inherits from 'Car'.

class Car:
    def __init__(self, brand, model):
        self.brand = brand
        self.model = model

    def drive(self):
        print(f"Driving {self.brand} {self.model}")

# 1. Create class ElectricCar inheriting from Car
# Your code here:


    # 2. Add an __init__ method that accepts brand, model, and battery_size
    # Use super() to call parent init
    # Your code here:


# 3. Create an instance of ElectricCar and call drive()
# my_ev = ElectricCar("Tesla", "Model 3", 75)
# my_ev.drive()
