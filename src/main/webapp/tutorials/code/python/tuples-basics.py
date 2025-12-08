# Python Tuples
# Tuples are ordered, IMMUTABLE collections.

# 1. Creating Tuples
my_tuple = ("apple", "banana", "cherry")
single_item_tuple = ("apple",) # Note the comma!

print(f"Tuple: {my_tuple}")
print(f"Type: {type(my_tuple)}")

# 2. Accessing Items (Same as lists)
print(f"First item: {my_tuple[0]}")

# 3. Immutability
# my_tuple[1] = "orange" # This would raise a TypeError!

# 4. Unpacking Tuples
fruits = ("apple", "banana", "cherry")
(green, yellow, red) = fruits

print(f"\nUnpacking:")
print(f"Green: {green}")
print(f"Yellow: {yellow}")
print(f"Red: {red}")

# 5. Using Asterisk *
fruits_2 = ("apple", "banana", "cherry", "strawberry", "raspberry")
(green, yellow, *red) = fruits_2

print(f"\nUnpacking with *:")
print(f"Green: {green}")
print(f"Yellow: {yellow}")
print(f"Red (rest): {red}") # Becomes a list
