# Python Regular Expressions (Regex)
# A RegEx, or Regular Expression, is a sequence of characters that forms a search pattern.
# Python has a built-in package called re, which can be used to work with Regular Expressions.

import re

txt = "The rain in Spain"

# 1. search()
# The search() function searches the string for a match, and returns a Match object if there is a match.
x = re.search("^The.*Spain$", txt)

if x:
  print("YES! We have a match!")
else:
  print("No match")

# 2. findall()
# The findall() function returns a list containing all matches.
x = re.findall("ai", txt)
print(x)

# 3. split()
# The split() function returns a list where the string has been split at each match.
x = re.split("\s", txt)
print(x)

# 4. sub()
# The sub() function replaces the matches with the text of your choice.
x = re.sub("\s", "9", txt)
print(x)

# 5. Match Object
# A Match Object is an object containing information about the search and the result.
x = re.search("ai", txt)
print(x.span()) # Tuple containing start-, and end positions of match
print(x.string) # The string passed into the function
print(x.group()) # The part of the string where there was a match

# 6. Metacharacters
# [] A set of characters "[a-m]"
# \  Signals a special sequence (can also be used to escape special characters) "\d"
# .  Any character (except newline character) "he..o"
# ^  Starts with "^hello"
# $  Ends with "planet$"
# *  Zero or more occurrences "he.*o"
# +  One or more occurrences "he.+o"
# ?  Zero or one occurrences "he.?o"
# {} Exactly the specified number of occurrences "he.{2}o"
# |  Either or "falls|stays"
