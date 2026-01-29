# Infinite Sequences with Generators

def infinite_counter():
    """Generator that counts forever."""
    count = 0
    while True:
        yield count
        count += 1

def fibonacci():
    """Generator that yields Fibonacci numbers indefinitely."""
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

def powers_of_two():
    """Generator that yields powers of 2: 1, 2, 4, 8, 16, ..."""
    power = 1
    while True:
        yield power
        power *= 2


# Using infinite generators with limits
print("First 10 numbers from infinite counter:")
counter = infinite_counter()
for i in range(10):
    print(next(counter), end=" ")
print()

print("\nFirst 10 Fibonacci numbers:")
fib = fibonacci()
for i in range(10):
    print(next(fib), end=" ")
print()

print("\nFirst 10 powers of 2:")
powers = powers_of_two()
for i in range(10):
    print(next(powers), end=" ")
print()

# Using with itertools.islice (cleaner way to limit)
print("\nUsing itertools.islice:")
from itertools import islice

print("Fibonacci numbers 20-29:")
fib2 = fibonacci()
for num in islice(fib2, 20, 30):  # Skip first 20, take next 10
    print(num, end=" ")
print()

# Practical: Reading from infinite stream
def simulate_data_stream():
    """Simulates reading from an infinite data source."""
    import random
    while True:
        yield random.randint(1, 100)

print("\nSimulated data stream (first 5 values):")
stream = simulate_data_stream()
for i, value in enumerate(stream):
    if i >= 5:
        break
    print(f"Data point {i+1}: {value}")





