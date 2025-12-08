# Practical Recursion Examples

# 1. Fibonacci sequence
print("=== Fibonacci ===")
def fibonacci(n):
    """Return the nth Fibonacci number."""
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

print("First 10 Fibonacci numbers:")
for i in range(10):
    print(fibonacci(i), end=" ")
print("\n")

# 2. Sum of a list
print("=== Sum of List ===")
def sum_list(lst):
    """Sum all elements in a list recursively."""
    if not lst:  # Empty list
        return 0
    return lst[0] + sum_list(lst[1:])

numbers = [1, 2, 3, 4, 5]
print(f"sum_list({numbers}) = {sum_list(numbers)}")
print()

# 3. Reverse a string
print("=== Reverse String ===")
def reverse_string(s):
    """Reverse a string recursively."""
    if len(s) <= 1:
        return s
    return reverse_string(s[1:]) + s[0]

text = "hello"
print(f"reverse('{text}') = '{reverse_string(text)}'")
print()

# 4. Check palindrome
print("=== Palindrome Check ===")
def is_palindrome(s):
    """Check if a string is a palindrome."""
    s = s.lower().replace(" ", "")  # Normalize
    if len(s) <= 1:
        return True
    if s[0] != s[-1]:
        return False
    return is_palindrome(s[1:-1])

words = ["radar", "hello", "level", "A man a plan a canal Panama"]
for word in words:
    result = is_palindrome(word)
    print(f"'{word}': {result}")
print()

# 5. Power function
print("=== Power Function ===")
def power(base, exp):
    """Calculate base^exp recursively."""
    if exp == 0:
        return 1
    if exp < 0:
        return 1 / power(base, -exp)
    return base * power(base, exp - 1)

print(f"2^5 = {power(2, 5)}")
print(f"3^4 = {power(3, 4)}")
print(f"2^-3 = {power(2, -3)}")
