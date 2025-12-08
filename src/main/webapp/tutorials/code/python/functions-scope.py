# Variable Scope
# Scope refers to the region where a variable is accessible.

# 1. Local Scope
def my_func():
    x = 300 # Local variable
    print(f"Inside function: {x}")

my_func()
# print(x) # This would raise an error because x is not defined globally

# 2. Global Scope
x = 300 # Global variable

def my_func_2():
    print(f"Inside function (global): {x}")

my_func_2()
print(f"Outside function: {x}")

# 3. Naming Conflict
x = 300

def my_func_3():
    x = 200 # Creates a new local variable x
    print(f"Inside function (local override): {x}")

my_func_3()
print(f"Outside function (global remains): {x}")

# 4. Global Keyword
def my_func_4():
    global x
    x = 200 # Modifies the global variable

my_func_4()
print(f"After global modification: {x}")
