# Lambda Function Basics

# 1. Basic lambda syntax
print("=== Basic Lambda ===")
# lambda arguments: expression

# A simple lambda that adds 10
add_ten = lambda x: x + 10
print(f"add_ten(5) = {add_ten(5)}")
print(f"add_ten(100) = {add_ten(100)}")
print()

# 2. Equivalent regular function
print("=== Lambda vs def ===")
# Lambda:
square_lambda = lambda x: x ** 2

# Equivalent def:
def square_def(x):
    return x ** 2

print(f"Lambda: {square_lambda(5)}")
print(f"Def:    {square_def(5)}")
print()

# 3. Multiple arguments
print("=== Multiple Arguments ===")
add = lambda a, b: a + b
multiply = lambda a, b: a * b
power = lambda base, exp: base ** exp

print(f"add(3, 5) = {add(3, 5)}")
print(f"multiply(4, 6) = {multiply(4, 6)}")
print(f"power(2, 8) = {power(2, 8)}")
print()

# 4. No arguments
print("=== No Arguments ===")
say_hello = lambda: "Hello, World!"
get_pi = lambda: 3.14159

print(say_hello())
print(f"Pi = {get_pi()}")
print()

# 5. Lambdas are expressions
print("=== Lambda as Expression ===")
# Can be used immediately without assigning
result = (lambda x, y: x + y)(3, 7)
print(f"Immediate call: {result}")

# In a list
operations = [
    lambda x: x + 1,
    lambda x: x * 2,
    lambda x: x ** 2
]

value = 5
for op in operations:
    print(f"Operation on {value}: {op(value)}")
