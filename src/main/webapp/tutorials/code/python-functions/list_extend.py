
fruits = ['apple', 'banana', 'cherry']
cars = ['Ford', 'BMW', 'Volvo']

# Extend list by appending elements from another list
fruits.extend(cars)
print(f"Extended list: {fruits}")

# Extend list with a tuple
fruits = ['apple', 'banana', 'cherry']
points = (1, 4, 5, 9)
fruits.extend(points)
print(f"Extended with tuple: {fruits}")
