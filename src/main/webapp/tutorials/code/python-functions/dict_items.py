
car = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}

# Return items object (tuples of key-value pairs)
x = car.items()
print(f"Items before update: {x}")

# Items view reflects changes
car["year"] = 2020
print(f"Items after update: {x}")

# Iterating items
print("\nIterating:")
for key, value in car.items():
    print(f"{key}: {value}")
