# Python Classes & Objects
# Python is an object oriented programming language.
# Almost everything in Python is an object, with its properties and methods.
# A Class is like an object constructor, or a "blueprint" for creating objects.

# 1. Create a Class
class MyClass:
    x = 5

# 2. Create Object
p1 = MyClass()
print(p1.x)

# 3. The __init__() Function
# All classes have a function called __init__(), which is always executed when the class is being initiated.
# Use the __init__() function to assign values to object properties.

class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

p1 = Person("John", 36)

print(p1.name)
print(p1.age)

# 4. The __str__() Function
# The __str__() function controls what should be returned when the class object is represented as a string.

class PersonStr:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def __str__(self):
        return f"{self.name}({self.age})"

p1 = PersonStr("John", 36)
print(p1)

# 5. Object Methods
# Objects can also contain methods. Methods in objects are functions that belong to the object.

class PersonMethod:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def myfunc(self):
        print("Hello my name is " + self.name)

p1 = PersonMethod("John", 36)
p1.myfunc()

# 6. The self Parameter
# The self parameter is a reference to the current instance of the class, and is used to access variables that belongs to the class.
# It does not have to be named 'self' , you can call it whatever you like, but it has to be the first parameter of any function in the class.
