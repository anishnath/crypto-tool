# Python Dictionaries
# Dictionaries are ordered (since 3.7), mutable collections of key-value pairs.

# 1. Creating Dictionaries
car = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}
print(f"Car: {car}")

# 2. Accessing Items
print(f"Model: {car['model']}")
print(f"Year (get): {car.get('year')}")

# 3. Modifying Items
car["year"] = 2020
car["color"] = "red" # Adding new key-value pair
print(f"Modified Car: {car}")

# 4. Removing Items
car.pop("model")
print(f"After pop: {car}")

# 5. Looping
print("\nKeys:")
for x in car:
    print(x)

print("\nValues:")
for x in car.values():
    print(x)

print("\nItems:")
for k, v in car.items():
    print(f"{k}: {v}")
