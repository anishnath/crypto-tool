
ages = [5, 12, 17, 18, 24, 32]

def myFunc(x):
    if x < 18:
        return False
    else:
        return True

# Standard filter
adults = filter(myFunc, ages)
print("Adults:", list(adults))

# Using lambda
result = filter(lambda x: x % 2 == 0, [1, 2, 3, 4, 5, 6, 7, 8])
print("Even numbers:", list(result))

# Remove None values
data = [1, None, "a", None, 5]
cleaned = filter(None, data)
print("Cleaned data:", list(cleaned))
