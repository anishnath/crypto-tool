# Practical Dictionary Comprehension Examples

# 1. Create lookup table
print("=== Lookup Table ===")
employees = ["Alice", "Bob", "Charlie", "Diana"]
# Create ID lookup (index as ID)
employee_ids = {name: f"EMP-{i+1:03d}" for i, name in enumerate(employees)}
print(f"Employee IDs: {employee_ids}")
print()

# 2. Invert a dictionary (swap keys/values)
print("=== Invert Dictionary ===")
country_codes = {"US": "United States", "UK": "United Kingdom", "CA": "Canada"}
code_lookup = {name: code for code, name in country_codes.items()}
print(f"Country codes: {country_codes}")
print(f"Code lookup: {code_lookup}")
print()

# 3. Count occurrences
print("=== Count Occurrences ===")
text = "hello world"
char_count = {char: text.count(char) for char in set(text)}
print(f"Text: '{text}'")
print(f"Char counts: {char_count}")
print()

# 4. Group by property
print("=== Group by First Letter ===")
words = ["apple", "banana", "apricot", "blueberry", "cherry", "avocado"]
# First item of each starting letter
first_of_letter = {word[0]: word for word in words}  # Later values overwrite
print(f"First of each letter: {first_of_letter}")
print()

# 5. Parse environment-style strings
print("=== Parse Config String ===")
config_str = "host=localhost;port=8080;debug=true"
config = {pair.split("=")[0]: pair.split("=")[1]
          for pair in config_str.split(";")}
print(f"Config string: {config_str}")
print(f"Parsed config: {config}")
print()

# 6. Create nested structure
print("=== Nested Structure ===")
users = ["alice", "bob", "charlie"]
user_profiles = {
    user: {"username": user, "email": f"{user}@example.com", "active": True}
    for user in users
}
print("User profiles:")
for name, profile in user_profiles.items():
    print(f"  {name}: {profile}")
print()

# 7. Merge and transform
print("=== Merge Two Dicts with Transform ===")
defaults = {"timeout": 30, "retries": 3, "debug": False}
overrides = {"timeout": 60, "debug": True}
# Merge with overrides taking precedence
merged = {**defaults, **overrides}
print(f"Defaults: {defaults}")
print(f"Overrides: {overrides}")
print(f"Merged: {merged}")
