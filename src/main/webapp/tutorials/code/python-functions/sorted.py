
a = ("b", "g", "a", "d", "f", "c", "h", "e")

# Basic sorting
x = sorted(a)
print(f"Sorted: {x}")

# Reverse sorting
y = sorted(a, reverse=True)
print(f"Reverse: {y}")

# Sorting with a key
def myFunc(e):
    return len(e)

cars = ['Ford', 'Mitsubishi', 'BMW', 'VW']
cars.sort(key=myFunc)
print(f"Sorted by length: {cars}")

# Case insensitive sort
strs = ['banana', 'Orange', 'Apple', 'cherry']
print(f"Case insensitive: {sorted(strs, key=str.lower)}")
