
car = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}

# Return keys object
x = car.keys()
print(f"Keys before update: {x}")

# Keys view reflects changes
car["color"] = "white"
print(f"Keys after update: {x}")

# Iterating keys
print("Iterating:")
for key in car.keys():
    print(key)
