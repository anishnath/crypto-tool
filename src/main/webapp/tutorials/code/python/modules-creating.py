# Creating Your Own Modules

# A module is just a Python file!
# If we had a file called 'mymodule.py', we could import it

# Let's simulate what a module file might contain:
print("=== What Goes in a Module ===")
print("""
# mymodule.py
# -----------
# Variables
PI = 3.14159
APP_NAME = "MyApp"

# Functions
def greet(name):
    return f"Hello, {name}!"

def add(a, b):
    return a + b

# Classes
class Calculator:
    def multiply(self, a, b):
        return a * b

# To use it:
# import mymodule
# print(mymodule.greet("Alice"))
# print(mymodule.PI)
""")

# Module-level code demonstration
print("=== Module Attributes ===")
# Every module has special attributes
print(f"Module name: {__name__}")  # __main__ when run directly
print(f"Module file: {__file__}" if '__file__' in dir() else "Running interactively")

# The if __name__ == "__main__" pattern
print()
print("=== The __name__ Pattern ===")
print("""
# In mymodule.py:
def main():
    print("Running as main program")

# This code only runs when the file is executed directly,
# NOT when it's imported
if __name__ == "__main__":
    main()
""")

# Example of module organization
print("=== Good Module Structure ===")
print("""
mymodule.py should have:
1. Docstring at the top (describes the module)
2. Imports
3. Constants (ALL_CAPS)
4. Classes
5. Functions
6. if __name__ == "__main__": block
""")
