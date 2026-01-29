import re

# Match pattern at the beginning of string
txt = "The rain in Spain"
x = re.match("^The", txt)

if x:
    print("Match found!")
    print(f"Match: {x.group()}")
else:
    print("No match")

# This won't match (not at beginning)
y = re.match("^rain", txt)
if y:
    print("Match found!")
else:
    print("No match - 'rain' is not at the beginning")
