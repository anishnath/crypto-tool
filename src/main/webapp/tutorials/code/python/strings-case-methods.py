# String Case Methods in Python
# Methods that change the case of strings

text = "hello World PYTHON"
print(f"Original: '{text}'")
print("=" * 40)

# upper() - convert all to uppercase
print(f"upper():      '{text.upper()}'")

# lower() - convert all to lowercase
print(f"lower():      '{text.lower()}'")

# capitalize() - first char uppercase, rest lowercase
print(f"capitalize(): '{text.capitalize()}'")

# title() - first char of each word uppercase
print(f"title():      '{text.title()}'")

# swapcase() - swap upper and lower
print(f"swapcase():   '{text.swapcase()}'")

# casefold() - aggressive lowercase (for caseless comparisons)
german = "Straße"  # German word with ß
print(f"\nGerman word: '{german}'")
print(f"lower():    '{german.lower()}'")
print(f"casefold(): '{german.casefold()}'")  # ß becomes ss

print("\n" + "=" * 40)
print("Practical Use Cases:")

# Case-insensitive comparison
user_input = "YES"
if user_input.lower() == "yes":
    print(f"User said yes (input was '{user_input}')")

# Formatting names
name = "jOHN DOE"
formatted = name.title()
print(f"Formatted name: {formatted}")

# Constants style
setting = "dark mode"
constant = setting.upper().replace(" ", "_")
print(f"Constant style: {constant}")
