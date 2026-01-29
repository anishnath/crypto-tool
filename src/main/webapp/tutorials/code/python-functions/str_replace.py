
# Simple replacement
txt = "I like bananas"
x = txt.replace("bananas", "apples")
print(f"Original: '{txt}'")
print(f"Replaced: '{x}'")

# Replace all occurrences
txt = "one one one two two three"
x = txt.replace("one", "three")
print(f"\nOriginal: '{txt}'")
print(f"Replace all 'one' -> 'three': '{x}'")

# Limit replacements
x = txt.replace("one", "three", 2)
print(f"Replace first 2 'one' -> 'three': '{x}'")
