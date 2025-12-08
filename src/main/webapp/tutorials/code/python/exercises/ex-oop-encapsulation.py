# Exercise: Encapsulation
# Task: Create a class with a private attribute.

class Person:
    def __init__(self, name, age):
        self.name = name
        # 1. Make age a private attribute (__age)
        self.__age = age

    # 2. Create a public method 'get_age' to return the age
    # Your code here:


p = Person("Alice", 30)

# 3. Print the age using the get_age method
# Your code here:

# 4. Try to access __age directly (it should fail)
# print(p.__age)
