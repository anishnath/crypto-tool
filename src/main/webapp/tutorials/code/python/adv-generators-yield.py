# Generator Functions and yield

def simple_generator():
    """A simple generator function using yield."""
    print("Generator started")
    yield 1
    print("After first yield")
    yield 2
    print("After second yield")
    yield 3
    print("Generator finished")


# Calling a generator function returns a generator object
gen = simple_generator()
print("Generator object:", gen)
print("Type:", type(gen))

# Generators are iterators - they have __iter__ and __next__
print("\nIterating through generator:")
for value in gen:
    print(f"Got value: {value}")

# Or use next() manually
print("\nManual iteration:")
gen2 = simple_generator()
print(next(gen2))  # Executes until first yield, returns 1
print(next(gen2))  # Resumes, executes until next yield, returns 2
print(next(gen2))  # Resumes, executes until next yield, returns 3
# next(gen2) would raise StopIteration


def counter(max_value):
    """Generator that counts up to max_value."""
    current = 0
    while current < max_value:
        yield current
        current += 1


print("\nCounter generator:")
for num in counter(5):
    print(num, end=" ")  # 0 1 2 3 4
print()





