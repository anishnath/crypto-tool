# List Methods
# Python provides many built-in methods for lists.

colors = ["red", "green", "blue"]
print(f"Original: {colors}")

# 1. Adding Items
colors.append("yellow")    # Adds to the end
print(f"After append: {colors}")

colors.insert(1, "orange") # Adds at index 1
print(f"After insert: {colors}")

more_colors = ["purple", "pink"]
colors.extend(more_colors) # Adds another list
print(f"After extend: {colors}")

# 2. Removing Items
colors.remove("green")     # Removes first occurrence
print(f"After remove: {colors}")

popped = colors.pop()      # Removes and returns last item
print(f"Popped item: {popped}")
print(f"After pop: {colors}")

# 3. Sorting and Reversing
numbers = [3, 1, 4, 1, 5, 9, 2]
numbers.sort()             # Sorts in-place
print(f"\nSorted numbers: {numbers}")

numbers.reverse()          # Reverses in-place
print(f"Reversed numbers: {numbers}")

# 4. Other methods
print(f"Count of 1: {numbers.count(1)}")
print(f"Index of 5: {numbers.index(5)}")
