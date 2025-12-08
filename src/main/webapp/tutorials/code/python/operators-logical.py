# Logical Operators in Python
# Used to combine conditional statements

a = True
b = False

print(f"a = {a}, b = {b}")

# 1. and - Returns True if both statements are true
print(f"a and b: {a and b}")
print(f"a and True: {a and True}")

# 2. or - Returns True if one of the statements is true
print(f"a or b: {a or b}")
print(f"b or False: {b or False}")

# 3. not - Reverse the result, returns False if the result is true
print(f"not a: {not a}")
print(f"not b: {not b}")

# Short-circuit evaluation
# In 'and', if the first operand is False, the second is not evaluated
# In 'or', if the first operand is True, the second is not evaluated

def check():
    print("Function executed!")
    return True

print("\nShort-circuit 'and':")
False and check() # check() is NOT executed

print("\nShort-circuit 'or':")
True or check()   # check() is NOT executed
