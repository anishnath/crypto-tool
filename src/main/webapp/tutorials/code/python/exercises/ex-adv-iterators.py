# Exercise: Create a Countdown Iterator
# Create a countdown iterator that counts down from a given number to 1,
# then raises StopIteration.

# TODO: Implement the Countdown class with __iter__ and __next__ methods
class Countdown:
    def __init__(self, start):
        # TODO: Initialize the starting number
        pass
    
    def __iter__(self):
        # TODO: Return self (the iterator)
        pass
    
    def __next__(self):
        # TODO: Return numbers in descending order (start, start-1, ..., 1)
        # TODO: Raise StopIteration when countdown reaches 0
        pass


# Test the iterator
print("Countdown from 5:")
for num in Countdown(5):
    print(num)

print("\nCountdown from 3:")
cd = Countdown(3)
it = iter(cd)
print(next(it))  # Should print 3
print(next(it))  # Should print 2
print(next(it))  # Should print 1
# next(it) should raise StopIteration
