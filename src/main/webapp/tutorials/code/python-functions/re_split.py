import re

# Split string by pattern
txt = "The rain in Spain"
x = re.split(r"\s", txt)
print(x)

# Split only at first occurrence
y = re.split(r"\s", txt, 1)
print(y)

# Split by multiple delimiters
txt2 = "apple,banana;cherry:date"
z = re.split(r"[,;:]", txt2)
print(z)
