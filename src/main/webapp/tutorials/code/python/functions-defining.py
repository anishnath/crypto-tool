# Defining Functions in Python

# 1. Basic function syntax
print("=== Basic Function ===")
def greet():
    """A simple function that prints a greeting."""
    print("Hello, World!")

# Call the function
greet()
print()

# 2. Function with one parameter
print("=== Single Parameter ===")
def greet_person(name):
    """Greet a specific person."""
    print(f"Hello, {name}!")

greet_person("Alice")
greet_person("Bob")
print()

# 3. Function with multiple parameters
print("=== Multiple Parameters ===")
def introduce(name, age, city):
    """Introduce someone with their details."""
    print(f"{name} is {age} years old and lives in {city}.")

introduce("Charlie", 25, "New York")
introduce("Diana", 30, "London")
print()

# 4. Function names follow same rules as variables
print("=== Naming Conventions ===")
# Good function names (snake_case)
def calculate_total():
    pass

def get_user_input():
    pass

def is_valid_email():  # Returns boolean
    pass

print("Use snake_case for function names")
print("Use descriptive verbs: calculate_, get_, is_, has_")
