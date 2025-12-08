# RegEx Patterns and Metacharacters

import re

# 1. Character classes
print("=== Character Classes ===")
text = "Hello World 123"
print(f"Text: '{text}'")
# Extract patterns to variables (f-strings can't have backslashes in expressions)
digits = re.findall(r'\d', text)
non_digits = re.findall(r'\D', text)
word_chars = re.findall(r'\w', text)
non_word = re.findall(r'\W', text)
whitespace = re.findall(r'\s', text)
print(f"\\d (digits): {digits}")
print(f"\\D (non-digits): {non_digits}")
print(f"\\w (word chars): {word_chars}")
print(f"\\W (non-word): {non_word}")
print(f"\\s (whitespace): {whitespace}")
print()

# 2. Custom character sets
print("=== Character Sets [...] ===")
text = "The cat sat on the mat"
print(f"[cm]at: {re.findall(r'[cm]at', text)}")  # cat or mat
print(f"[a-z]: {re.findall(r'[a-z]', 'A1b2C3')}")  # lowercase
print(f"[^aeiou]: {re.findall(r'[^aeiou ]', text)}")  # not vowels
print()

# 3. Quantifiers
print("=== Quantifiers ===")
text = "goood morning, gd"
print(f"go+d: {re.findall(r'go+d', text)}")   # 1 or more o
print(f"go*d: {re.findall(r'go*d', text)}")   # 0 or more o
print(f"go?d: {re.findall(r'go?d', text)}")   # 0 or 1 o

text = "12 345 6789"
two_to_three_digits = re.findall(r'\d{2,3}', text)
print(f"\\d{{2,3}}: {two_to_three_digits}")  # 2-3 digits
print()

# 4. Anchors
print("=== Anchors ===")
text = "hello world hello"
start_hello = re.findall(r'^hello', text)
end_hello = re.findall(r'hello$', text)
word_boundary_hello = re.findall(r'\bhello\b', text)
print(f"^hello: {start_hello}")  # Start
print(f"hello$: {end_hello}")  # End
print(f"\\bhello\\b: {word_boundary_hello}")  # Word boundary
print()

# 5. Alternation and grouping
print("=== Alternation (|) ===")
text = "I have a cat and a dog"
print(f"cat|dog: {re.findall(r'cat|dog', text)}")
print(f"(cat|dog)s?: {re.findall(r'(cat|dog)s?', 'cats and dogs')}")
