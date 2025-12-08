# List Comprehensions with Conditions (Filtering)

# Syntax: [expression for item in iterable if condition]

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
print(f"Original: {numbers}")
print()

# Filter even numbers
print("=== Basic Filtering ===")
evens = [x for x in numbers if x % 2 == 0]
print(f"Even numbers: {evens}")

odds = [x for x in numbers if x % 2 != 0]
print(f"Odd numbers: {odds}")

greater_than_5 = [x for x in numbers if x > 5]
print(f"Greater than 5: {greater_than_5}")
print()

# Combining transformation and filtering
print("=== Transform + Filter ===")
# Square of even numbers only
even_squares = [x ** 2 for x in numbers if x % 2 == 0]
print(f"Squares of evens: {even_squares}")
print()

# Filtering strings
print("=== String Filtering ===")
fruits = ["apple", "banana", "cherry", "date", "elderberry", "fig"]
print(f"Fruits: {fruits}")

# Words containing 'a'
with_a = [f for f in fruits if 'a' in f]
print(f"Contains 'a': {with_a}")

# Words longer than 5 characters
long_words = [f for f in fruits if len(f) > 5]
print(f"Longer than 5: {long_words}")

# Words starting with vowel
vowels = 'aeiou'
start_vowel = [f for f in fruits if f[0] in vowels]
print(f"Starts with vowel: {start_vowel}")
print()

# Multiple conditions (AND)
print("=== Multiple Conditions ===")
# Even AND greater than 4
both = [x for x in numbers if x % 2 == 0 and x > 4]
print(f"Even AND > 4: {both}")

# Contains 'a' AND longer than 5
both_str = [f for f in fruits if 'a' in f and len(f) > 5]
print(f"Has 'a' AND len > 5: {both_str}")
