# Exercise: Find the First Even Number
# Task: Find the first even number in a list and stop.

numbers = [1, 3, 5, 7, 8, 9, 10]
found_even = -1

# 1. Iterate through the list.
# 2. If you find an even number, store it in 'found_even' and BREAK the loop.
# 3. If the number is odd, CONTINUE to the next iteration (optional, but good practice).

for num in numbers:
    # Your code here
    pass

if found_even != -1:
    print(f"First even number found: {found_even}")
else:
    print("No even numbers found.")
