# Local Scope in Python

# 1. Variables inside functions are local
print("=== Local Variables ===")
def greet():
    message = "Hello!"  # Local to this function
    print(message)

greet()
# print(message)  # NameError: message is not defined
print()

# 2. Parameters are local too
print("=== Parameters Are Local ===")
def add(a, b):
    result = a + b  # result is local
    return result

print(add(3, 5))
# print(a)  # NameError: a is not defined
# print(result)  # NameError: result is not defined
print()

# 3. Local variables shadow global ones
print("=== Local Shadows Global ===")
x = 100  # Global

def show_x():
    x = 50  # Local - shadows the global x
    print(f"Inside function: x = {x}")

show_x()
print(f"Outside function: x = {x}")  # Global unchanged
print()

# 4. Each function call creates new locals
print("=== Fresh Locals Each Call ===")
def counter():
    count = 0  # Fresh local each time
    count += 1
    return count

print(f"First call: {counter()}")
print(f"Second call: {counter()}")
print(f"Third call: {counter()}")
print()

# 5. Local variables exist only during function execution
print("=== Lifetime of Locals ===")
def temp_data():
    data = [1, 2, 3, 4, 5]  # Created
    total = sum(data)
    return total
    # data and total are destroyed after return

result = temp_data()
print(f"Result: {result}")
# data is gone - can't access it here
