# Arbitrary Arguments: *args and **kwargs

# 1. *args - Accept any number of positional arguments
print("=== *args (Arbitrary Positional) ===")
def sum_all(*numbers):
    """Sum any number of arguments."""
    print(f"Received: {numbers}")  # It's a tuple!
    return sum(numbers)

print(f"Sum: {sum_all(1, 2, 3)}")
print(f"Sum: {sum_all(10, 20, 30, 40, 50)}")
print(f"Sum: {sum_all()}")  # Empty tuple OK
print()

# 2. **kwargs - Accept any number of keyword arguments
print("=== **kwargs (Arbitrary Keyword) ===")
def print_info(**info):
    """Print any keyword arguments passed."""
    print(f"Received: {info}")  # It's a dictionary!
    for key, value in info.items():
        print(f"  {key}: {value}")

print_info(name="Alice", age=25)
print_info(city="New York", country="USA", code="10001")
print()

# 3. Combining with regular parameters
print("=== Combining Parameters ===")
def make_pizza(size, *toppings, **extras):
    """Make a pizza with size, toppings, and extras."""
    print(f"\n{size.title()} pizza:")
    print(f"  Toppings: {', '.join(toppings) if toppings else 'plain'}")
    if extras:
        for key, value in extras.items():
            print(f"  {key}: {value}")

make_pizza("large", "pepperoni", "mushrooms")
make_pizza("medium", "cheese", extra_sauce=True, crust="thin")
make_pizza("small", delivery=True, tip=5.00)
print()

# 4. Unpacking arguments
print("=== Unpacking Arguments ===")
def introduce(name, age, city):
    print(f"{name}, {age} years old, from {city}")

# Unpack list/tuple with *
person = ["Alice", 25, "Paris"]
introduce(*person)

# Unpack dict with **
person_dict = {"name": "Bob", "age": 30, "city": "London"}
introduce(**person_dict)
