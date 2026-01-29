
# Min of two numbers
x = min(5, 10)
print(f"min(5, 10) = {x}")

# Min of multiple arguments
y = min("Mike", "John", "Vicky")
print(f"min('Mike', 'John', 'Vicky') = {y}")

# Min of an iterable
a = (1, 5, 3, 9)
print(f"min((1, 5, 3, 9)) = {min(a)}")

# Min with key function
s = ["longword", "short", "medium"]
print(f"Shortest word: {min(s, key=len)}")
