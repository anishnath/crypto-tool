import re

# Replace pattern with string
txt = "The rain in Spain"
x = re.sub("Spain", "Norway", txt)
print(x)

# Replace all whitespace with underscore
y = re.sub(r"\s", "_", txt)
print(y)

# Replace only first 2 occurrences
txt2 = "one two one two one"
z = re.sub("one", "three", txt2, 2)
print(z)
