# Python Class Methods
# Methods are functions that are defined inside a class.

class MyClass:
    class_variable = "I am a class variable"

    def __init__(self, value):
        self.instance_variable = value

    # 1. Instance Methods
    # Takes 'self' as the first parameter. Can modify object state and class state.
    def instance_method(self):
        return f"Instance method called. Value: {self.instance_variable}"

    # 2. Class Methods
    # Takes 'cls' as the first parameter. Can modify class state that applies across all instances of the class.
    @classmethod
    def class_method(cls):
        return f"Class method called. Class variable: {cls.class_variable}"

    # 3. Static Methods
    # Does not take 'self' or 'cls'. Behaves like a plain function but belongs to the class's namespace.
    @staticmethod
    def static_method():
        return "Static method called. I don't know about class or instance."

# Usage
obj = MyClass(10)

print(obj.instance_method())
print(MyClass.class_method())
print(MyClass.static_method())
print(obj.static_method()) # Can also be called on instance
