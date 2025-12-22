# String Patterns for Interviews
# Common string problems and solutions

print("=== Pattern 1: Valid Palindrome (Ignore Non-Alphanumeric) ===\n")

def is_valid_palindrome(s):
    """Check if string is palindrome, ignoring non-alphanumeric"""
    # Filter and lowercase
    cleaned = ''.join(c.lower() for c in s if c.isalnum())
    
    # Two pointers
    left, right = 0, len(cleaned) - 1
    while left < right:
        if cleaned[left] != cleaned[right]:
            return False
        left += 1
        right -= 1
    
    return True

test = "A man, a plan, a canal: Panama"
print(f"String: '{test}'")
print(f"Valid palindrome: {is_valid_palindrome(test)} ✅\n")


print("=== Pattern 2: First Unique Character ===\n")

def first_unique_char(s):
    """Find index of first non-repeating character"""
    freq = {}
    
    # Count frequencies
    for char in s:
        freq[char] = freq.get(char, 0) + 1
    
    # Find first with count 1
    for i, char in enumerate(s):
        if freq[char] == 1:
            return i
    
    return -1

s = "leetcode"
index = first_unique_char(s)
print(f"String: '{s}'")
print(f"First unique char at index {index}: '{s[index]}'\n")


print("=== Pattern 3: Longest Common Prefix ===\n")

def longest_common_prefix(strs):
    """Find longest common prefix among strings"""
    if not strs:
        return ""
    
    # Start with first string
    prefix = strs[0]
    
    for s in strs[1:]:
        # Shrink prefix until it matches
        while not s.startswith(prefix):
            prefix = prefix[:-1]
            if not prefix:
                return ""
    
    return prefix

words = ["flower", "flow", "flight"]
print(f"Words: {words}")
print(f"Common prefix: '{longest_common_prefix(words)}'\n")


print("=== Pattern 4: String Compression ===\n")

def compress_string(s):
    """Compress: 'aaabbc' -> 'a3b2c1'"""
    if not s:
        return ""
    
    compressed = []
    count = 1
    
    for i in range(1, len(s)):
        if s[i] == s[i-1]:
            count += 1
        else:
            compressed.append(s[i-1] + str(count))
            count = 1
    
    # Don't forget last group
    compressed.append(s[-1] + str(count))
    
    result = ''.join(compressed)
    # Return original if compression doesn't help
    return result if len(result) < len(s) else s

s = "aaabbc"
print(f"Original: '{s}'")
print(f"Compressed: '{compress_string(s)}'\n")


print("=== Pattern 5: Substring Search (Naive) ===\n")

def find_substring(text, pattern):
    """Find first occurrence of pattern in text"""
    n, m = len(text), len(pattern)
    
    for i in range(n - m + 1):
        if text[i:i+m] == pattern:
            return i
    
    return -1

text = "hello world"
pattern = "wor"
index = find_substring(text, pattern)
print(f"Text: '{text}'")
print(f"Pattern: '{pattern}'")
print(f"Found at index: {index}\n")


print("=== Interview Patterns Summary ===")
print("1. Two Pointers: Palindrome, reverse")
print("2. Hash Map: Frequency, anagrams, unique chars")
print("3. Sliding Window: Longest/shortest substring")
print("4. String Building: Compression, manipulation")
print("5. Pattern Matching: Substring search")
