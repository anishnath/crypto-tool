# Practical Function Examples

# 1. Temperature converter
print("=== Temperature Converter ===")
def celsius_to_fahrenheit(celsius):
    """Convert Celsius to Fahrenheit."""
    return (celsius * 9/5) + 32

def fahrenheit_to_celsius(fahrenheit):
    """Convert Fahrenheit to Celsius."""
    return (fahrenheit - 32) * 5/9

print(f"0°C = {celsius_to_fahrenheit(0)}°F")
print(f"100°C = {celsius_to_fahrenheit(100)}°F")
print(f"98.6°F = {fahrenheit_to_celsius(98.6):.1f}°C")
print()

# 2. String utilities
print("=== String Utilities ===")
def clean_string(text):
    """Remove extra whitespace and convert to lowercase."""
    return " ".join(text.split()).lower()

def count_words(text):
    """Count the number of words in a string."""
    return len(text.split())

messy = "   Hello    World   "
print(f"Original: '{messy}'")
print(f"Cleaned: '{clean_string(messy)}'")
print(f"Word count: {count_words(messy)}")
print()

# 3. Validation functions
print("=== Validation Functions ===")
def is_valid_age(age):
    """Check if age is a valid positive number."""
    return isinstance(age, int) and 0 <= age <= 150

def is_valid_email(email):
    """Basic email validation (contains @ and .)"""
    return "@" in email and "." in email

print(f"is_valid_age(25): {is_valid_age(25)}")
print(f"is_valid_age(-5): {is_valid_age(-5)}")
print(f"is_valid_email('test@example.com'): {is_valid_email('test@example.com')}")
print(f"is_valid_email('invalid'): {is_valid_email('invalid')}")
print()

# 4. List processing
print("=== List Processing ===")
def get_evens(numbers):
    """Return only even numbers from a list."""
    return [n for n in numbers if n % 2 == 0]

def get_sum_and_avg(numbers):
    """Return both sum and average of a list."""
    total = sum(numbers)
    avg = total / len(numbers) if numbers else 0
    return total, avg  # Return multiple values as tuple

nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
print(f"Numbers: {nums}")
print(f"Evens: {get_evens(nums)}")
total, avg = get_sum_and_avg(nums)
print(f"Sum: {total}, Average: {avg}")
