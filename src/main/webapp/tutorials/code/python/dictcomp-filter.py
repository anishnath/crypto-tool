# Dictionary Comprehensions with Filtering

# Syntax: {key: value for item in iterable if condition}

scores = {"Alice": 85, "Bob": 72, "Charlie": 91, "Diana": 68, "Eve": 95}
print(f"All scores: {scores}")
print()

# 1. Filter by value
print("=== Filter by Value ===")
passing = {name: score for name, score in scores.items() if score >= 75}
print(f"Passing (>=75): {passing}")

failing = {name: score for name, score in scores.items() if score < 75}
print(f"Failing (<75): {failing}")
print()

# 2. Filter by key
print("=== Filter by Key ===")
# Names starting with specific letter
names_e = {name: score for name, score in scores.items() if name.startswith("E")}
print(f"Names starting with 'E': {names_e}")

# Names with length > 3
long_names = {name: score for name, score in scores.items() if len(name) > 3}
print(f"Names longer than 3 chars: {long_names}")
print()

# 3. Multiple conditions
print("=== Multiple Conditions ===")
# Passing scores for names with 5+ characters
filtered = {name: score for name, score in scores.items()
            if score >= 75 and len(name) >= 5}
print(f"Passing + long names: {filtered}")
print()

# 4. Filter numbers
print("=== Filtering Number Dicts ===")
numbers = {x: x**2 for x in range(10)}
print(f"All squares: {numbers}")

# Only even keys
even_keys = {k: v for k, v in numbers.items() if k % 2 == 0}
print(f"Even keys only: {even_keys}")

# Only values > 25
big_values = {k: v for k, v in numbers.items() if v > 25}
print(f"Values > 25: {big_values}")
print()

# 5. Remove specific keys
print("=== Remove Specific Keys ===")
original = {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5}
remove_keys = {"b", "d"}
filtered = {k: v for k, v in original.items() if k not in remove_keys}
print(f"Original: {original}")
print(f"After removing {remove_keys}: {filtered}")
