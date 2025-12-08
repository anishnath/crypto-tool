# The nonlocal Keyword - Modifying Enclosing Scope

# 1. The problem: can't modify enclosing by default
print("=== The Problem ===")
def make_counter_wrong():
    count = 0

    def increment():
        count += 1  # UnboundLocalError!
        return count

    return increment

# counter = make_counter_wrong()
# counter()  # Would fail
print()

# 2. Solution: nonlocal keyword
print("=== Using nonlocal ===")
def make_counter():
    count = 0

    def increment():
        nonlocal count  # Modify the enclosing variable
        count += 1
        return count

    return increment

counter = make_counter()
print(f"First: {counter()}")
print(f"Second: {counter()}")
print(f"Third: {counter()}")
print()

# 3. nonlocal vs global
print("=== nonlocal vs global ===")
level = "module"

def outer():
    level = "outer"

    def inner_nonlocal():
        nonlocal level  # Modifies outer's level
        level = "inner changed outer"

    def inner_global():
        global level  # Modifies module's level
        level = "inner changed global"

    print(f"Before nonlocal: outer={level}")
    inner_nonlocal()
    print(f"After nonlocal: outer={level}")

outer()
print(f"Module level: {level}")
print()

# 4. Practical use: closures with state
print("=== Closure with State ===")
def make_multiplier(factor):
    """Create a function that multiplies by factor."""
    def multiply(n):
        return n * factor  # Reads from enclosing (no nonlocal needed for read)
    return multiply

double = make_multiplier(2)
triple = make_multiplier(3)

print(f"double(5) = {double(5)}")
print(f"triple(5) = {triple(5)}")
print()

# 5. State in closures (needs nonlocal for modification)
print("=== Stateful Closure ===")
def make_accumulator():
    """Create a function that accumulates values."""
    total = 0

    def add(value):
        nonlocal total
        total += value
        return total

    return add

acc = make_accumulator()
print(f"Add 10: {acc(10)}")
print(f"Add 5: {acc(5)}")
print(f"Add 3: {acc(3)}")
