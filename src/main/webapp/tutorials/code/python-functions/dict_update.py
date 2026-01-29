
car = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}

# Update specific item
car.update({"year": 2020})
print(f"Updated year: {car}")

# Add new item via update
car.update({"color": "White"})
print(f"Added color: {car}")

# Update with iterable of key-value pairs
car.update([("transmission", "Automatic"), ("owner", "John")])
print(f"Updated with list of tuples: {car}")
