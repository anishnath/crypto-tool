
# Default split (whitespace)
txt = "welcome to the jungle"
x = txt.split()
print(f"Original: '{txt}'")
print(f"Split: {x}")

# Specifying delimiter
txt = "apple,banana,cherry"
x = txt.split(",")
print(f"\nOriginal: '{txt}'")
print(f"Split by comma: {x}")

# Limiting splits
txt = "apple#banana#cherry#orange"
x = txt.split("#", 1)
print(f"\nOriginal: '{txt}'")
print(f"Max split 1: {x}")
