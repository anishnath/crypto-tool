# The super() Function

print("=== Using super() ===\n")

# 1. Why we need super()
print("1. Problem: Child __init__ hides parent __init__:")

class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

class StudentBad(Person):
    def __init__(self, name, age, student_id):
        # Without calling parent __init__, name and age aren't set!
        self.student_id = student_id

# Uncomment to see the error:
# bad = StudentBad("Alice", 20, "S123")
# print(bad.name)  # AttributeError: 'StudentBad' has no attribute 'name'
print("   Without super(), parent attributes aren't initialized!")
print()

# 2. Solution: Use super() to call parent
print("2. Using super() to call parent __init__:")

class Student(Person):
    def __init__(self, name, age, student_id):
        super().__init__(name, age)  # Call parent's __init__
        self.student_id = student_id

student = Student("Alice", 20, "S123")
print(f"   Name: {student.name}")  # From Person
print(f"   Age: {student.age}")    # From Person
print(f"   ID: {student.student_id}")  # From Student
print()

# 3. super() with methods
print("3. Using super() with other methods:")

class Animal:
    def speak(self):
        return "Some generic sound"

class Dog(Animal):
    def speak(self):
        # Call parent method AND add to it
        parent_sound = super().speak()
        return f"{parent_sound}... actually, Woof!"

dog = Dog()
print(f"   {dog.speak()}")
print()

# 4. Extending parent methods
print("4. Extending parent behavior:")

class Employee:
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary

    def get_info(self):
        return f"Name: {self.name}, Salary: ${self.salary:,}"

class Manager(Employee):
    def __init__(self, name, salary, department):
        super().__init__(name, salary)  # Initialize Employee part
        self.department = department
        self.team = []

    def get_info(self):
        # Extend parent's get_info
        base_info = super().get_info()
        return f"{base_info}, Department: {self.department}, Team size: {len(self.team)}"

    def add_to_team(self, employee):
        self.team.append(employee)

mgr = Manager("Bob", 75000, "Engineering")
emp = Employee("Alice", 50000)
mgr.add_to_team(emp)

print(f"   Employee: {emp.get_info()}")
print(f"   Manager: {mgr.get_info()}")
print()

# 5. Why super() instead of ParentClass.method()?
print("5. super() vs explicit parent call:")

class A:
    def greet(self):
        return "Hello from A"

class B(A):
    def greet(self):
        # Old way - hardcodes parent class name
        # return A.greet(self) + ", and B"

        # Better - uses super(), works with multiple inheritance
        return super().greet() + ", and B"

b = B()
print(f"   {b.greet()}")
print()
print("   super() advantages:")
print("   - Doesn't hardcode parent class name")
print("   - Works correctly with multiple inheritance")
print("   - Follows Method Resolution Order (MRO)")
