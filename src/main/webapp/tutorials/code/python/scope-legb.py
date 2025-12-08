# The LEGB Rule - Python's Scope Resolution

# LEGB = Local, Enclosing, Global, Built-in

# 1. The LEGB lookup order
print("=== LEGB Lookup Order ===")
x = "global"  # Global

def outer():
    x = "enclosing"  # Enclosing (for inner function)

    def inner():
        x = "local"  # Local
        print(f"Inside inner: {x}")  # Finds local

    inner()
    print(f"Inside outer: {x}")  # Finds enclosing

outer()
print(f"Outside: {x}")  # Finds global
print()

# 2. Without local, uses enclosing
print("=== Enclosing Scope ===")
def outer2():
    message = "from outer"

    def inner2():
        # No local 'message', so uses enclosing
        print(f"Inner sees: {message}")

    inner2()

outer2()
print()

# 3. Built-in scope
print("=== Built-in Scope ===")
# Built-ins are always available
print(f"len([1,2,3]) = {len([1, 2, 3])}")
print(f"max(5, 10) = {max(5, 10)}")
print(f"type('hello') = {type('hello')}")

# But can be shadowed (usually by accident!)
# Don't do this:
# list = [1, 2, 3]  # Shadows built-in list()
# print(list([1, 2]))  # TypeError!
print()

# 4. Demonstrating full LEGB
print("=== Full LEGB Demo ===")
name = "Global Name"  # G

def outer_func():
    name = "Enclosing Name"  # E

    def inner_func():
        name = "Local Name"  # L
        # Also available: len, print, etc. (B)
        print(f"Inner: {name}")
        print(f"Built-in len: {len(name)}")

    inner_func()
    print(f"Outer: {name}")

outer_func()
print(f"Module: {name}")
