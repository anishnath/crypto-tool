# Collection Type Conversions in Python
# Converting between list, tuple, set, dict, and string

print("=" * 50)
print("1. Converting to List: list()")
print("=" * 50)

# From string (each character becomes an element)
s = "hello"
print(f"list('{s}') = {list(s)}")

# From tuple
t = (1, 2, 3)
print(f"list({t}) = {list(t)}")

# From set (order not guaranteed)
st = {3, 1, 2}
print(f"list({st}) = {list(st)}")

# From dictionary (gets keys)
d = {"a": 1, "b": 2}
print(f"list({d}) = {list(d)}")
print(f"list({d}.values()) = {list(d.values())}")
print(f"list({d}.items()) = {list(d.items())}")

# From range
r = range(5)
print(f"list(range(5)) = {list(r)}")

print("\n" + "=" * 50)
print("2. Converting to Tuple: tuple()")
print("=" * 50)

# From list
lst = [1, 2, 3]
print(f"tuple({lst}) = {tuple(lst)}")

# From string
print(f"tuple('abc') = {tuple('abc')}")

# Tuples are immutable - useful for dict keys
point = tuple([10, 20])
print(f"Immutable point: {point}")

print("\n" + "=" * 50)
print("3. Converting to Set: set()")
print("=" * 50)

# From list (removes duplicates!)
lst = [1, 2, 2, 3, 3, 3]
print(f"set({lst}) = {set(lst)}")

# From string
print(f"set('hello') = {set('hello')}")  # Unique chars only

# Useful for removing duplicates
numbers = [1, 2, 2, 3, 1, 4, 3]
unique = list(set(numbers))
print(f"\nRemoving duplicates:")
print(f"  Original: {numbers}")
print(f"  Unique:   {unique}")

# Note: order may not be preserved!
# To preserve order, use dict.fromkeys() in Python 3.7+
unique_ordered = list(dict.fromkeys(numbers))
print(f"  Ordered:  {unique_ordered}")

print("\n" + "=" * 50)
print("4. Converting to Dictionary: dict()")
print("=" * 50)

# From list of tuples
pairs = [("a", 1), ("b", 2), ("c", 3)]
print(f"dict({pairs})")
print(f"  = {dict(pairs)}")

# From two lists using zip
keys = ["name", "age", "city"]
values = ["Alice", 25, "NYC"]
print(f"\ndict(zip({keys}, {values}))")
print(f"  = {dict(zip(keys, values))}")

# From dict comprehension (alternative)
squares = {x: x**2 for x in range(1, 6)}
print(f"\nDict comprehension: {squares}")

print("\n" + "=" * 50)
print("5. Converting String to/from List")
print("=" * 50)

# String to list of characters
text = "Python"
chars = list(text)
print(f"list('{text}') = {chars}")

# List of characters back to string
text_back = ''.join(chars)
print(f"''.join({chars}) = '{text_back}'")

# String to list of words (split)
sentence = "Hello World Python"
words = sentence.split()
print(f"'{sentence}'.split() = {words}")

# List of words back to string (join)
sentence_back = ' '.join(words)
print(f"' '.join({words}) = '{sentence_back}'")

print("\n" + "=" * 50)
print("6. Practical Examples")
print("=" * 50)

# Counting unique items
items = ["apple", "banana", "apple", "cherry", "banana"]
unique_count = len(set(items))
print(f"Unique items in {items}: {unique_count}")

# Inverting a dictionary
original = {"a": 1, "b": 2, "c": 3}
inverted = dict(zip(original.values(), original.keys()))
print(f"\nOriginal: {original}")
print(f"Inverted: {inverted}")

# Converting query string to dict
query = "name=Alice&age=25&city=NYC"
pairs = [p.split('=') for p in query.split('&')]
params = dict(pairs)
print(f"\nQuery string: {query}")
print(f"As dict: {params}")
