# Python Decorators
# Decorators are a very powerful and useful tool in Python since it allows programmers to modify the behaviour of function or class.
# Decorators allow us to wrap another function in order to extend the behaviour of the wrapped function, without permanently modifying it.

# 1. First Class Objects
# In Python, functions are first class objects which means that functions in Python can be used or passed as arguments.

def shout(text):
    return text.upper()

def whisper(text):
    return text.lower()

def greet(func):
    # storing the function in a variable
    greeting = func("""Hi, I am created by a function passed as an argument.""")
    print(greeting)

greet(shout)
greet(whisper)

# 2. Simple Decorator
def my_decorator(func):
    def wrapper():
        print("Something is happening before the function is called.")
        func()
        print("Something is happening after the function is called.")
    return wrapper

def say_whee():
    print("Whee!")

say_whee = my_decorator(say_whee)
say_whee()

# 3. The "Pie" Syntax @
# Python provides a simpler way to apply decorators using the @ symbol.

@my_decorator
def say_whee_pie():
    print("Whee with Pie Syntax!")

say_whee_pie()

# 4. Decorating Functions with Arguments
def do_twice(func):
    def wrapper_do_twice(*args, **kwargs):
        func(*args, **kwargs)
        func(*args, **kwargs)
    return wrapper_do_twice

@do_twice
def greet_name(name):
    print(f"Hello {name}")

greet_name("World")
