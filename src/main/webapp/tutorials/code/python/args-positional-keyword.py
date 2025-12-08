# Positional and Keyword Arguments

# 1. Positional Arguments - order matters!
print("=== Positional Arguments ===")
def greet(first_name, last_name):
    """Greet someone using their full name."""
    print(f"Hello, {first_name} {last_name}!")

# Order determines which parameter gets which value
greet("John", "Smith")  # first_name="John", last_name="Smith"
greet("Smith", "John")  # first_name="Smith", last_name="John" (wrong!)
print()

# 2. Keyword Arguments - explicit parameter names
print("=== Keyword Arguments ===")
def describe_pet(animal_type, pet_name):
    """Display information about a pet."""
    print(f"I have a {animal_type} named {pet_name}.")

# Order doesn't matter with keyword arguments
describe_pet(animal_type="hamster", pet_name="Harry")
describe_pet(pet_name="Harry", animal_type="hamster")  # Same result!
print()

# 3. Mixing positional and keyword
print("=== Mixing Both ===")
def make_shirt(size, text, color="white"):
    """Create a shirt with a message."""
    print(f"{color.title()} {size} shirt: '{text}'")

# Positional first, then keyword
make_shirt("L", "Python Rocks", color="blue")
make_shirt("M", text="Hello World")

# This would be an error:
# make_shirt(size="L", "Bad Order")  # SyntaxError!
print()

# 4. Why use keyword arguments?
print("=== Benefits of Keyword Arguments ===")
def create_user(username, email, age, city, active=True):
    """Create a user profile."""
    return {
        "username": username,
        "email": email,
        "age": age,
        "city": city,
        "active": active
    }

# More readable with keyword arguments
user = create_user(
    username="alice",
    email="alice@example.com",
    age=25,
    city="New York"
)
print(f"User: {user}")
