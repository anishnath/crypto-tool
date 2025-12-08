# The Iterator Protocol: __iter__ and __next__

class NumberSequence:
    """Custom iterator that implements the iterator protocol."""
    
    def __init__(self, start, end):
        self.current = start
        self.end = end
    
    def __iter__(self):
        """Returns the iterator object itself."""
        return self
    
    def __next__(self):
        """Returns the next value or raises StopIteration."""
        if self.current < self.end:
            value = self.current
            self.current += 1
            return value
        else:
            raise StopIteration  # Signal that iteration is complete


# Using the custom iterator
print("NumberSequence from 1 to 5:")
nums = NumberSequence(1, 5)

# Manual iteration
print("Manual iteration:")
print(next(nums))  # 1
print(next(nums))  # 2
print(next(nums))  # 3

# Using for loop (handles StopIteration automatically)
print("\nFor loop iteration:")
for num in NumberSequence(1, 5):
    print(num)

# Using iter() and next() explicitly
print("\nUsing iter() and next():")
it = iter(NumberSequence(10, 13))
print(next(it))  # 10
print(next(it))  # 11
print(next(it))  # 12
# next(it) would raise StopIteration here

