# Python Generators
# Generators are a simple way of creating iterators.
# A generator is a function that returns an object (iterator) which we can iterate over (one value at a time).

# 1. Generator Function
# It is defined like a normal function, but whenever it needs to generate a value, it does so with the yield keyword rather than return.
# If the body of a def contains yield, the function automatically becomes a generator function.

def my_generator():
    yield 1
    yield 2
    yield 3

# Driver code to check above generator function
for value in my_generator():
    print(value)

# 2. Generator Object
# Generator functions return a generator object. Generator objects are used either by calling the next method on the generator object or using the generator object in a "for in" loop.

def simpleGeneratorFun():
    yield 1
    yield 2
    yield 3

x = simpleGeneratorFun()

print(next(x))
print(next(x))
print(next(x))

# 3. Generator Expression
# Simple generators can be easily created using generator expressions. It makes building generators easy.
# Similar to lambda functions which create anonymous functions, generator expressions create anonymous generator functions.
# The syntax for generator expression is similar to that of a list comprehension in Python. But the square brackets are replaced with round parentheses.

# Initialize the list
my_list = [1, 3, 6, 10]

# square each term using list comprehension
list_ = [x**2 for x in my_list]

# same thing can be done using a generator expression
# generator expressions are surrounded by parenthesis ()
generator = (x**2 for x in my_list)

print(list_)
print(generator)

print(next(generator))
print(next(generator))
