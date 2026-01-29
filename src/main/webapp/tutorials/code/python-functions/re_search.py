import re

# Search for pattern anywhere in string
txt = "The rain in Spain"
x = re.search("rain", txt)

if x:
    print("Match found!")
    print(f"Position: {x.start()}-{x.end()}")
    print(f"Match: {x.group()}")
else:
    print("No match")

# Search with pattern
y = re.search(r"\s", txt)  # Find first whitespace
if y:
    print(f"\nFirst whitespace at position: {y.start()}")
