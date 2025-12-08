# String Checking Methods in Python
# Methods that return True/False about string content

print("=" * 50)
print("Character Type Checks")
print("=" * 50)

# Test strings
tests = ["Hello", "hello123", "12345", "   ", "Hello World", ""]

for s in tests:
    display = f"'{s}'" if s else "''"
    print(f"\n{display:15} (len={len(s)})")
    if s:  # Skip empty string for most checks
        print(f"  isalpha():    {s.isalpha()}")     # Only letters
        print(f"  isdigit():    {s.isdigit()}")     # Only digits
        print(f"  isalnum():    {s.isalnum()}")     # Letters or digits
        print(f"  isspace():    {s.isspace()}")     # Only whitespace

print("\n" + "=" * 50)
print("Case Checks")
print("=" * 50)

cases = ["HELLO", "hello", "Hello World", "hello world", "123"]
for s in cases:
    print(f"\n'{s}'")
    print(f"  isupper(): {s.isupper()}")
    print(f"  islower(): {s.islower()}")
    print(f"  istitle(): {s.istitle()}")

print("\n" + "=" * 50)
print("Numeric Checks (more specific)")
print("=" * 50)

# Different numeric string types
nums = ["123", "12.34", "-123", "½", "²", "Ⅳ"]
for n in nums:
    print(f"'{n}':  isdigit()={n.isdigit()}, isnumeric()={n.isnumeric()}, isdecimal()={n.isdecimal() if hasattr(n, 'isdecimal') else 'N/A'}")

print("\n" + "=" * 50)
print("Practical Examples")
print("=" * 50)

# Validate username (alphanumeric only)
def is_valid_username(name):
    return name.isalnum() and len(name) >= 3

usernames = ["john123", "jane_doe", "ab", "user@123"]
for u in usernames:
    valid = "✓" if is_valid_username(u) else "✗"
    print(f"  {u:10} -> {valid}")

# Check if string is a valid integer
def is_integer(s):
    s = s.strip()
    if s.startswith('-') or s.startswith('+'):
        s = s[1:]
    return s.isdigit() and len(s) > 0

numbers = ["123", "-456", "+789", "12.34", "abc"]
print("\nInteger validation:")
for n in numbers:
    valid = "✓" if is_integer(n) else "✗"
    print(f"  {n:8} -> {valid}")
