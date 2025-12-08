# Global Scope and the global Keyword

# 1. Global variables
print("=== Global Variables ===")
APP_NAME = "MyApp"  # Global - accessible everywhere
version = "1.0"

def show_app_info():
    # Can READ global variables without special syntax
    print(f"App: {APP_NAME} v{version}")

show_app_info()
print()

# 2. Can't modify globals without 'global' keyword
print("=== The Problem ===")
counter = 0

def increment_wrong():
    # This creates a NEW local variable, doesn't modify global!
    counter = counter + 1  # UnboundLocalError!

# increment_wrong()  # Would raise UnboundLocalError
print()

# 3. Using the global keyword
print("=== Using 'global' ===")
counter = 0

def increment_right():
    global counter  # Now we're modifying the global
    counter += 1

print(f"Before: {counter}")
increment_right()
increment_right()
increment_right()
print(f"After: {counter}")
print()

# 4. Creating globals from functions
print("=== Creating Globals ===")
def create_global():
    global new_var
    new_var = "I was created inside a function!"

create_global()
print(new_var)  # Works - it's now a global
print()

# 5. Why global is often discouraged
print("=== Better Alternatives ===")
# Instead of global state:
def get_incremented(current):
    """Return incremented value - no global state."""
    return current + 1

value = 0
value = get_incremented(value)
value = get_incremented(value)
print(f"Value: {value}")

# Or use a class to encapsulate state
class Counter:
    def __init__(self):
        self.count = 0

    def increment(self):
        self.count += 1
        return self.count

c = Counter()
print(f"Counter: {c.increment()}, {c.increment()}, {c.increment()}")
