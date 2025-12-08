# Exercise: Fibonacci Generator
# Create a generator function that produces Fibonacci numbers.
# The Fibonacci sequence: 0, 1, 1, 2, 3, 5, 8, 13, 21, ...

# TODO: Implement the fibonacci() generator function
def fibonacci():
    """
    Generator that yields Fibonacci numbers indefinitely.
    
    The Fibonacci sequence starts with 0, 1, and each subsequent
    number is the sum of the previous two.
    """
    # TODO: Initialize first two Fibonacci numbers
    # TODO: Use a while True loop
    # TODO: Yield the first number
    # TODO: Update the numbers for the next iteration
    pass


# Test the generator
print("First 10 Fibonacci numbers:")
fib = fibonacci()
for i in range(10):
    print(next(fib))

print("\nUsing for loop with enumerate:")
for i, num in enumerate(fibonacci()):
    if i >= 10:
        break
    print(f"F({i}) = {num}")
