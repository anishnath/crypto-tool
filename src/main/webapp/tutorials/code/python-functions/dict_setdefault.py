
car = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}

# Get "model" item
x = car.setdefault("model", "Bronco")
print(f"Model: {x}")
# "model" existed, so it was returned and not updated

# Get "color" item (does not exist)
y = car.setdefault("color", "White")
print(f"Color: {y}")
print(f"Dict after setdefault: {car}")
# "color" did not exist, so "White" was inserted and returned
