# enumerate() - Get Index and Value Together

fruits = ["apple", "banana", "cherry", "date"]

# Without enumerate (manual index tracking)
print("=== Without enumerate (manual) ===")
index = 0
for fruit in fruits:
    print(f"{index}: {fruit}")
    index += 1

print()

# With enumerate (much cleaner!)
print("=== With enumerate ===")
for index, fruit in enumerate(fruits):
    print(f"{index}: {fruit}")

print()

# Starting index from a different number
print("=== enumerate with start=1 ===")
for num, fruit in enumerate(fruits, start=1):
    print(f"{num}. {fruit}")

print()

# Practical example: Finding item position
print("=== Finding Item Position ===")
names = ["Alice", "Bob", "Charlie", "Diana"]
search_name = "Charlie"

for index, name in enumerate(names):
    if name == search_name:
        print(f"Found '{search_name}' at position {index}")
        break

print()

# Creating a numbered menu
print("=== Numbered Menu ===")
options = ["New Game", "Load Game", "Settings", "Exit"]
for i, option in enumerate(options, start=1):
    print(f"[{i}] {option}")
