# Creating Custom Iterators

class SquareNumbers:
    """Iterator that yields squares of numbers up to a limit."""
    
    def __init__(self, limit):
        self.limit = limit
        self.num = 0
    
    def __iter__(self):
        self.num = 0  # Reset for new iteration
        return self
    
    def __next__(self):
        if self.num < self.limit:
            square = self.num ** 2
            self.num += 1
            return square
        else:
            raise StopIteration


# Using the custom iterator
print("Square numbers up to 5:")
squares = SquareNumbers(5)

for sq in squares:
    print(sq)  # 0, 1, 4, 9, 16

# Iterator is consumed after use
print("\nTrying to iterate again (will be empty):")
for sq in squares:
    print(sq)  # Nothing prints - iterator is exhausted

# Create a new iterator
print("\nNew iterator:")
for sq in SquareNumbers(5):
    print(sq)


class CountDown:
    """Iterator that counts down from start to 1."""
    
    def __init__(self, start):
        self.current = start + 1  # +1 because we decrement first
    
    def __iter__(self):
        return self
    
    def __next__(self):
        self.current -= 1
        if self.current > 0:
            return self.current
        else:
            raise StopIteration


print("\nCountdown from 5:")
for num in CountDown(5):
    print(f"T-minus {num}")

