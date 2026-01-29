
txt = "Hello my FRIENDS"

x = txt.lower()

print(f"Original: '{txt}'")
print(f"Lower case: '{x}'")

# Check if islower
print(f"Is '{x}' lower? {x.islower()}")

# Casefold (stronger lower casing)
s = "ß"
print(f"Lower 'ß': {s.lower()}")
print(f"Casefold 'ß': {s.casefold()}")
