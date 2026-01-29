
# Max of two numbers
x = max(5, 10)
print(f"max(5, 10) = {x}")

# Max of multiple arguments
y = max("Mike", "John", "Vicky")
print(f"max('Mike', 'John', 'Vicky') = {y}")

# Max of an iterable
a = (1, 5, 3, 9)
print(f"max((1, 5, 3, 9)) = {max(a)}")

# Max with key function
s = ["longword", "short", "medium"]
print(f"Longest word: {max(s, key=len)}")
