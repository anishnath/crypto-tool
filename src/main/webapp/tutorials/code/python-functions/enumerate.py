
fruits = ["apple", "banana", "cherry"]

# Standard enumeration (starts at 0)
print("Standard enumeration:")
for index, fruit in enumerate(fruits):
    print(f"Index {index}: {fruit}")

print("\nEnumeration starting at 1:")
# Enumeration specifying start index
for index, fruit in enumerate(fruits, start=1):
    print(f"Number {index}: {fruit}")

# Converting enumerate object to list
enum_list = list(enumerate(fruits))
print(f"\nAs list: {enum_list}")
