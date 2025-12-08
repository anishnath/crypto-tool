# Python Inheritance
# Inheritance allows us to define a class that inherits all the methods and properties from another class.

# Parent class (Base class)
class Person:
    def __init__(self, fname, lname):
        self.firstname = fname
        self.lastname = lname

    def printname(self):
        print(self.firstname, self.lastname)

# 1. Create a Child Class (Derived class)
class Student(Person):
    pass

x = Student("Mike", "Olsen")
x.printname()

# 2. Add __init__() function
# When you add the __init__() function, the child class will no longer inherit the parent's __init__() function.
# To keep the inheritance of the parent's __init__() function, add a call to the parent's __init__() function:

class StudentInit(Person):
    def __init__(self, fname, lname, year):
        # Person.__init__(self, fname, lname) # Old way
        super().__init__(fname, lname) # New way using super()
        self.graduationyear = year

    def welcome(self):
        print("Welcome", self.firstname, self.lastname, "to the class of", self.graduationyear)

x = StudentInit("Mike", "Olsen", 2019)
x.welcome()

# 3. Multiple Inheritance
class A:
    def method_a(self):
        print("Method A")

class B:
    def method_b(self):
        print("Method B")

class C(A, B):
    pass

c = C()
c.method_a()
c.method_b()
