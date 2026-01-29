
cars = ['Ford', 'BMW', 'Volvo']

# Sort alphabetically (ascending)
cars.sort()
print(f"Sorted: {cars}")

# Sort descending
cars.sort(reverse=True)
print(f"Reverse sorted: {cars}")

# Sort by key (length of string)
def myFunc(e):
  return len(e)

cars = ['Ford', 'Mitsubishi', 'BMW', 'VW']
cars.sort(key=myFunc)
print(f"Sorted by length: {cars}")
