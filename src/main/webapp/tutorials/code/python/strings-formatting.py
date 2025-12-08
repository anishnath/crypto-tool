# String Formatting in Python
# Multiple ways to format strings

name = "Alice"
age = 25
price = 49.99

print("=" * 50)
print("1. f-strings (Python 3.6+) - RECOMMENDED")
print("=" * 50)
print(f"Name: {name}, Age: {age}")
print(f"Price: ${price}")
print(f"Math: 2 + 3 = {2 + 3}")
print(f"Function: {name.upper()}")

print("\n" + "=" * 50)
print("2. f-string Formatting Options")
print("=" * 50)
# Width and alignment
print(f"Right align: '{name:>10}'")
print(f"Left align:  '{name:<10}'")
print(f"Center:      '{name:^10}'")

# Number formatting
pi = 3.14159265359
print(f"2 decimals: {pi:.2f}")
print(f"5 decimals: {pi:.5f}")

# Thousands separator
big_num = 1234567
print(f"With commas: {big_num:,}")

# Percentage
ratio = 0.856
print(f"Percentage: {ratio:.1%}")

print("\n" + "=" * 50)
print("3. .format() Method")
print("=" * 50)
print("Name: {}, Age: {}".format(name, age))
print("Name: {0}, Age: {1}".format(name, age))
print("Name: {n}, Age: {a}".format(n=name, a=age))

print("\n" + "=" * 50)
print("4. % Operator (Old Style)")
print("=" * 50)
print("Name: %s, Age: %d" % (name, age))
print("Price: %.2f" % price)

print("\n" + "=" * 50)
print("5. String Concatenation")
print("=" * 50)
print("Hello, " + name + "! You are " + str(age) + " years old.")

print("\n" + "=" * 50)
print("Summary: Use f-strings for most cases!")
