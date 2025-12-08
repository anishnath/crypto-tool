# Tuple Unpacking - Extracting Values

# Basic unpacking
print("=== Basic Unpacking ===")
coordinates = (10, 20, 30)
x, y, z = coordinates
print(f"Tuple: {coordinates}")
print(f"x={x}, y={y}, z={z}")
print()

# Swapping variables (elegant Python idiom!)
print("=== Variable Swapping ===")
a, b = 5, 10
print(f"Before: a={a}, b={b}")
a, b = b, a  # No temp variable needed!
print(f"After:  a={a}, b={b}")
print()

# Unpacking in function returns
print("=== Function Return Unpacking ===")
def get_stats(numbers):
    return min(numbers), max(numbers), sum(numbers)

data = [4, 2, 9, 1, 5, 6]
minimum, maximum, total = get_stats(data)
print(f"Data: {data}")
print(f"Min: {minimum}, Max: {maximum}, Sum: {total}")
print()

# Extended unpacking with * (Python 3+)
print("=== Extended Unpacking (*) ===")
numbers = (1, 2, 3, 4, 5, 6, 7)

first, *middle, last = numbers
print(f"first={first}, middle={middle}, last={last}")

head, *tail = numbers
print(f"head={head}, tail={tail}")

*init, final = numbers
print(f"init={init}, final={final}")
print()

# Ignoring values with underscore
print("=== Ignoring Values ===")
data = ("John", "Doe", 25, "Engineer", "New York")
first_name, last_name, _, _, city = data
print(f"Name: {first_name} {last_name}, City: {city}")

# Ignore multiple with *_
name, *_, location = data
print(f"Name: {name}, Location: {location}")
print()

# Unpacking in for loops
print("=== Unpacking in Loops ===")
points = [(0, 0), (1, 2), (3, 4)]
for x, y in points:
    print(f"  Point: x={x}, y={y}")
