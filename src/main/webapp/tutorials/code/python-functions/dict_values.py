
car = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}

# Return values object
x = car.values()
print(f"Values before update: {x}")

# Values view reflects changes
car["year"] = 2020
print(f"Values after update: {x}")

# Add new item
car["color"] = "red"
print(f"Values after add: {x}")
