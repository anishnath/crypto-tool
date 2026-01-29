
# Removing leading/trailing whitespace
txt = "     banana     "
x = txt.strip()
print(f"Original: '{txt}'")
print(f"Stripped: '{x}'")

# Removing specific characters
txt = ",,,,,rrttgg.....banana....rrr"
x = txt.strip(",.grt")
print(f"\nOriginal: '{txt}'")
print(f"Stripped ',.grt': '{x}'")

# lstrip and rstrip
txt = "     banana     "
l = txt.lstrip()
r = txt.rstrip()
print(f"\nLeft stripped: '{l}'")
print(f"Right stripped: '{r}'")
