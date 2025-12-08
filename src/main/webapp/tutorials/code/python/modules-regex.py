# Python RegEx
# A RegEx, or Regular Expression, is a sequence of characters that forms a search pattern.

import re

txt = "The rain in Spain"

# 1. Search (Returns a Match object if there is a match anywhere)
x = re.search("^The.*Spain$", txt)
if x:
  print("YES! We have a match!")
else:
  print("No match")

# 2. Findall (Returns a list containing all matches)
x = re.findall("ai", txt)
print(f"Findall 'ai': {x}")

# 3. Split (Returns a list where the string has been split at each match)
x = re.split("\s", txt)
print(f"Split by whitespace: {x}")

# 4. Sub (Replaces the matches with the text of your choice)
x = re.sub("\s", "9", txt)
print(f"Sub whitespace with 9: {x}")
