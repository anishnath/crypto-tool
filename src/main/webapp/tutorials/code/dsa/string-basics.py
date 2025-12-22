# String Manipulation Basics
# Essential string operations and patterns

print("=== String Basics ===\n")

# Strings are immutable in Python
s = "Hello"
print(f"Original: '{s}'")
# s[0] = 'h'  # Error! Can't modify

# Create new string instead
s = s.lower()
print(f"Lowercase: '{s}'\n")


print("=== Common Operations ===\n")

text = "  Python Programming  "

# 1. Strip whitespace
print(f"Original: '{text}'")
print(f"Stripped: '{text.strip()}'\n")

# 2. Split and join
words = "hello,world,python".split(',')
print(f"Split: {words}")
print(f"Join: {'-'.join(words)}\n")

# 3. Replace
message = "I love Java"
print(f"Original: {message}")
print(f"Replace: {message.replace('Java', 'Python')}\n")


print("=== Pattern: Reverse a String ===\n")

def reverse_string(s):
    """Two pointers approach"""
    chars = list(s)  # Convert to list (mutable)
    left, right = 0, len(chars) - 1
    
    while left < right:
        chars[left], chars[right] = chars[right], chars[left]
        left += 1
        right -= 1
    
    return ''.join(chars)

s = "hello"
print(f"Original: '{s}'")
print(f"Reversed: '{reverse_string(s)}'\n")


print("=== Pattern: Check Palindrome ===\n")

def is_palindrome(s):
    """Two pointers from both ends"""
    left, right = 0, len(s) - 1
    
    while left < right:
        if s[left] != s[right]:
            return False
        left += 1
        right -= 1
    
    return True

test_cases = ["racecar", "hello", "madam"]
for word in test_cases:
    result = "✅" if is_palindrome(word) else "❌"
    print(f"{result} '{word}' is palindrome: {is_palindrome(word)}")

print("\n=== Pattern: Character Frequency ===\n")

def char_frequency(s):
    """Count character occurrences"""
    freq = {}
    for char in s:
        freq[char] = freq.get(char, 0) + 1
    return freq

s = "programming"
freq = char_frequency(s)
print(f"String: '{s}'")
print(f"Frequency: {freq}\n")


print("=== Pattern: Anagram Check ===\n")

def are_anagrams(s1, s2):
    """Two strings are anagrams if they have same characters"""
    if len(s1) != len(s2):
        return False
    return sorted(s1) == sorted(s2)

pairs = [("listen", "silent"), ("hello", "world")]
for s1, s2 in pairs:
    result = "✅" if are_anagrams(s1, s2) else "❌"
    print(f"{result} '{s1}' and '{s2}': {are_anagrams(s1, s2)}")

print("\n=== Key Takeaways ===")
print("✅ Strings are immutable - create new strings")
print("✅ Use two pointers for reversal/palindrome")
print("✅ Use hash maps for frequency/anagrams")
print("✅ Sliding window for substring problems")
