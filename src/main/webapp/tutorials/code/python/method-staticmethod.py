# Static Methods with @staticmethod

print("=== Static Methods ===\n")

# 1. Basic static method
print("1. Basic static method:")

class MathUtils:
    @staticmethod
    def add(a, b):
        """Static method - no self or cls parameter."""
        return a + b

    @staticmethod
    def multiply(a, b):
        return a * b

    @staticmethod
    def is_even(n):
        return n % 2 == 0

# Call on class - no instance needed
print(f"   add(5, 3): {MathUtils.add(5, 3)}")
print(f"   multiply(4, 7): {MathUtils.multiply(4, 7)}")
print(f"   is_even(10): {MathUtils.is_even(10)}")

# Can also call on instance (but why?)
m = MathUtils()
print(f"   Via instance: {m.add(2, 2)}")
print()

# 2. Utility functions in a class
print("2. Utility functions in a class:")

class StringUtils:
    @staticmethod
    def is_palindrome(s):
        """Check if string is palindrome."""
        s = s.lower().replace(" ", "")
        return s == s[::-1]

    @staticmethod
    def word_count(text):
        """Count words in text."""
        return len(text.split())

    @staticmethod
    def capitalize_words(text):
        """Capitalize first letter of each word."""
        return " ".join(word.capitalize() for word in text.split())

print(f"   'radar' palindrome? {StringUtils.is_palindrome('radar')}")
print(f"   'hello' palindrome? {StringUtils.is_palindrome('hello')}")
print(f"   Word count: {StringUtils.word_count('Hello World Python')}")
print(f"   Capitalize: {StringUtils.capitalize_words('hello world')}")
print()

# 3. Validation helpers
print("3. Validation helpers:")

class Validator:
    @staticmethod
    def is_valid_email(email):
        """Simple email validation."""
        return '@' in email and '.' in email.split('@')[-1]

    @staticmethod
    def is_valid_phone(phone):
        """Check if phone has 10 digits."""
        digits = ''.join(c for c in phone if c.isdigit())
        return len(digits) == 10

    @staticmethod
    def is_strong_password(password):
        """Check password strength."""
        has_upper = any(c.isupper() for c in password)
        has_lower = any(c.islower() for c in password)
        has_digit = any(c.isdigit() for c in password)
        return len(password) >= 8 and has_upper and has_lower and has_digit

print(f"   Valid email 'test@example.com': {Validator.is_valid_email('test@example.com')}")
print(f"   Valid email 'invalid': {Validator.is_valid_email('invalid')}")
print(f"   Strong password 'Pass1234': {Validator.is_strong_password('Pass1234')}")
print(f"   Strong password 'weak': {Validator.is_strong_password('weak')}")
print()

# 4. Static vs regular function
print("4. Why use static method vs regular function?")
print("""
   Static methods are good when:
   - Function is logically related to the class
   - You want to namespace related utilities
   - Could be a module-level function but belongs with class

   Regular functions are fine when:
   - Function is general-purpose
   - No logical connection to a specific class
""")

# 5. Practical example
print("5. Practical example - Date utilities:")

class DateUtils:
    DAYS_IN_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    @staticmethod
    def is_leap_year(year):
        """Check if year is a leap year."""
        return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)

    @staticmethod
    def days_in_month(month, year):
        """Get days in a month."""
        if month == 2 and DateUtils.is_leap_year(year):
            return 29
        return DateUtils.DAYS_IN_MONTH[month - 1]

    @staticmethod
    def is_valid_date(day, month, year):
        """Validate a date."""
        if month < 1 or month > 12:
            return False
        if day < 1 or day > DateUtils.days_in_month(month, year):
            return False
        return True

print(f"   2024 leap year? {DateUtils.is_leap_year(2024)}")
print(f"   2023 leap year? {DateUtils.is_leap_year(2023)}")
print(f"   Days in Feb 2024: {DateUtils.days_in_month(2, 2024)}")
print(f"   Valid date 31/4/2024? {DateUtils.is_valid_date(31, 4, 2024)}")
print(f"   Valid date 30/4/2024? {DateUtils.is_valid_date(30, 4, 2024)}")
