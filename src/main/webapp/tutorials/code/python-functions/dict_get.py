
car = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}

# Get value of "model"
x = car.get("model")
print(f"Model: {x}")

# Get value of "price" (not in dict)
y = car.get("price", 15000)
print(f"Price (default): {y}")

# Without default, returns None if not found
z = car.get("color")
print(f"Color: {z}")
