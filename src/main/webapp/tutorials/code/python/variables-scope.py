# Variable Scope in Python

# Global variable
message = "I am global"

def show_scope():
    # Local variable (shadows global)
    message = "I am local"
    print(f"Inside function: {message}")

def use_global():
    # Access global variable
    print(f"Using global: {message}")

def modify_global():
    global message  # Declare we want to use global
    message = "Modified globally"
    print(f"After modification: {message}")

# Demonstrate scope
print(f"Before function: {message}")
show_scope()
print(f"After show_scope: {message}")  # Global unchanged

use_global()

modify_global()
print(f"Final value: {message}")  # Global was changed
