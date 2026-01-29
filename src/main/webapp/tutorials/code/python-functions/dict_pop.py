
car = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}

# Remove "model"
x = car.pop("model")
print(f"Popped value: {x}")
print(f"Dict after pop: {car}")

# Try to pop non-existing with default
y = car.pop("color", "No color specified")
print(f"Popped 'color': {y}")
