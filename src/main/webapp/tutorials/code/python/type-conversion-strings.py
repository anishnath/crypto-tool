# String Type Conversions in Python
# Converting to and from strings

print("=" * 50)
print("1. Converting Numbers to Strings")
print("=" * 50)

num = 42
pi = 3.14159

# Using str()
print(f"str(42) = '{str(num)}'")
print(f"str(3.14159) = '{str(pi)}'")

# Formatting numbers as strings
print(f"\nFormatting options:")
print(f"  f'{{pi:.2f}}' = '{pi:.2f}'")      # 2 decimal places
print(f"  f'{{num:05d}}' = '{num:05d}'")    # Zero-padded
print(f"  f'{{num:,}}' = '{1000000:,}'")    # Thousands separator

# repr() vs str()
print(f"\nstr() vs repr():")
s = "hello"
print(f"  str('{s}'): {str(s)}")      # hello
print(f"  repr('{s}'): {repr(s)}")    # 'hello' (with quotes)

print("\n" + "=" * 50)
print("2. Converting Strings to Numbers")
print("=" * 50)

# String to integer
print(f"int('123') = {int('123')}")
print(f"int('  42  ') = {int('  42  ')}")  # Whitespace OK

# String to float
print(f"float('3.14') = {float('3.14')}")
print(f"float('2.5e-3') = {float('2.5e-3')}")

# Handling invalid input
print("\nWhat happens with invalid input:")
try:
    result = int("hello")
except ValueError as e:
    print(f"  int('hello') raises: ValueError")

try:
    result = int("3.14")  # Can't convert float string directly to int!
except ValueError as e:
    print(f"  int('3.14') raises: ValueError")

# Correct way: convert to float first, then int
print(f"  int(float('3.14')) = {int(float('3.14'))}")

print("\n" + "=" * 50)
print("3. Working with Characters")
print("=" * 50)

# ord() - character to ASCII/Unicode number
print("ord() - character to number:")
print(f"  ord('A') = {ord('A')}")   # 65
print(f"  ord('a') = {ord('a')}")   # 97
print(f"  ord('0') = {ord('0')}")   # 48

# chr() - number to character
print("\nchr() - number to character:")
print(f"  chr(65) = '{chr(65)}'")   # A
print(f"  chr(97) = '{chr(97)}'")   # a
print(f"  chr(128512) = '{chr(128512)}'")  # 😀

print("\n" + "=" * 50)
print("4. Number Formatting Tricks")
print("=" * 50)

num = 255

# Different bases
print(f"Converting {num} to different bases:")
print(f"  bin({num}) = {bin(num)}")    # 0b11111111
print(f"  oct({num}) = {oct(num)}")    # 0o377
print(f"  hex({num}) = {hex(num)}")    # 0xff

# Remove prefix
print(f"\nWithout prefix:")
print(f"  bin({num})[2:] = {bin(num)[2:]}")
print(f"  format({num}, 'b') = {format(num, 'b')}")
print(f"  f'{{{num}:08b}}' = {num:08b}")  # 8 digits, zero-padded

print("\n" + "=" * 50)
print("5. Practical Examples")
print("=" * 50)

# User input is always string
user_input = "25"
age = int(user_input)
print(f"Processing age from input '{user_input}': {age + 10} in 10 years")

# Building URLs or file paths
base_url = "https://api.example.com/users/"
user_id = 42
url = base_url + str(user_id)
print(f"URL: {url}")

# Better: use f-strings
url = f"{base_url}{user_id}"
print(f"Better URL: {url}")
