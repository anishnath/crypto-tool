"""
DP on Strings
Palindrome problems, Word Break, and other string DP problems
"""

# ============================================================================
# LONGEST PALINDROMIC SUBSEQUENCE
# ============================================================================

def longest_palindromic_subsequence(s):
    """
    Longest Palindromic Subsequence (LPS)
    
    dp[i][j] = LPS length of s[i:j+1]
    dp[i][j] = dp[i+1][j-1] + 2 if s[i] == s[j]
             = max(dp[i+1][j], dp[i][j-1]) otherwise
    """
    print(f"\n🔤 Longest Palindromic Subsequence")
    print(f"   String: {s}")
    
    n = len(s)
    dp = [[0] * n for _ in range(n)]
    
    # Base case: single character is palindrome of length 1
    for i in range(n):
        dp[i][i] = 1
    
    # Fill for lengths 2 to n
    for length in range(2, n + 1):
        for i in range(n - length + 1):
            j = i + length - 1
            if s[i] == s[j]:
                if length == 2:
                    dp[i][j] = 2
                else:
                    dp[i][j] = dp[i + 1][j - 1] + 2
            else:
                dp[i][j] = max(dp[i + 1][j], dp[i][j - 1])
    
    print(f"\n✓ LPS length: {dp[0][n - 1]}")
    return dp[0][n - 1]

# ============================================================================
# LONGEST PALINDROMIC SUBSTRING
# ============================================================================

def longest_palindromic_substring(s):
    """
    Longest Palindromic Substring (continuous)
    
    dp[i][j] = True if s[i:j+1] is palindrome
    dp[i][j] = True if s[i] == s[j] and dp[i+1][j-1]
    """
    print(f"\n🔤 Longest Palindromic Substring")
    print(f"   String: {s}")
    
    n = len(s)
    if not s:
        return ""
    
    dp = [[False] * n for _ in range(n)]
    start, max_len = 0, 1
    
    # Single character is palindrome
    for i in range(n):
        dp[i][i] = True
    
    # Check for length 2
    for i in range(n - 1):
        if s[i] == s[i + 1]:
            dp[i][i + 1] = True
            start = i
            max_len = 2
    
    # Check for length 3 and more
    for length in range(3, n + 1):
        for i in range(n - length + 1):
            j = i + length - 1
            if s[i] == s[j] and dp[i + 1][j - 1]:
                dp[i][j] = True
                start = i
                max_len = length
    
    result = s[start:start + max_len]
    print(f"\n✓ Longest palindromic substring: '{result}' (length: {max_len})")
    return result

# ============================================================================
# PALINDROME PARTITIONING (MINIMUM CUTS)
# ============================================================================

def min_palindrome_cuts(s):
    """
    Minimum cuts to partition string into palindromes
    """
    n = len(s)
    if not s:
        return 0
    
    # Precompute palindrome table
    is_palindrome = [[False] * n for _ in range(n)]
    
    # Single characters
    for i in range(n):
        is_palindrome[i][i] = True
    
    # Length 2
    for i in range(n - 1):
        is_palindrome[i][i + 1] = (s[i] == s[i + 1])
    
    # Length 3+
    for length in range(3, n + 1):
        for i in range(n - length + 1):
            j = i + length - 1
            is_palindrome[i][j] = (s[i] == s[j] and is_palindrome[i + 1][j - 1])
    
    # DP: minimum cuts
    dp = [0] * (n + 1)
    
    for i in range(1, n + 1):
        dp[i] = i - 1  # Worst case: cut after each character
        for j in range(i):
            if is_palindrome[j][i - 1]:
                dp[i] = min(dp[i], dp[j] + 1)
    
    return dp[n]

# ============================================================================
# WORD BREAK
# ============================================================================

def word_break(s, word_dict):
    """
    Word Break: Can string be segmented into dictionary words?
    
    dp[i] = can s[0:i] be segmented?
    dp[i] = True if exists j < i such that dp[j] and s[j:i] in word_dict
    """
    print(f"\n📚 Word Break")
    print(f"   String: {s}")
    print(f"   Dictionary: {word_dict}")
    
    n = len(s)
    dp = [False] * (n + 1)
    dp[0] = True  # Empty string can be segmented
    
    for i in range(1, n + 1):
        for j in range(i):
            if dp[j] and s[j:i] in word_dict:
                dp[i] = True
                break
    
    print(f"\n✓ Can be segmented: {dp[n]}")
    return dp[n]

def word_break_all(s, word_dict):
    """
    Word Break II: Return all possible sentences
    """
    def backtrack(start, memo):
        if start in memo:
            return memo[start]
        
        if start == len(s):
            return [""]
        
        result = []
        for end in range(start + 1, len(s) + 1):
            word = s[start:end]
            if word in word_dict:
                for sentence in backtrack(end, memo):
                    if sentence:
                        result.append(word + " " + sentence)
                    else:
                        result.append(word)
        
        memo[start] = result
        return result
    
    return backtrack(0, {})

# ============================================================================
# EDIT DISTANCE (STRING ALIGNMENT)
# ============================================================================

def edit_distance_detailed(word1, word2):
    """
    Edit Distance with operation tracking
    """
    m, n = len(word1), len(word2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    # Base cases
    for i in range(m + 1):
        dp[i][0] = i
    for j in range(n + 1):
        dp[0][j] = j
    
    # Fill DP table
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if word1[i - 1] == word2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1]
            else:
                dp[i][j] = min(
                    dp[i - 1][j] + 1,      # Delete
                    dp[i][j - 1] + 1,      # Insert
                    dp[i - 1][j - 1] + 1   # Replace
                )
    
    return dp[m][n]

# ============================================================================
# DISTINCT SUBSEQUENCES
# ============================================================================

def num_distinct_subsequences(s, t):
    """
    Distinct Subsequences: How many times t appears as subsequence in s?
    
    dp[i][j] = number of distinct subsequences of s[0:i] that equals t[0:j]
    """
    print(f"\n🔍 Distinct Subsequences")
    print(f"   String: {s}")
    print(f"   Pattern: {t}")
    
    m, n = len(s), len(t)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    # Empty pattern matches empty string
    for i in range(m + 1):
        dp[i][0] = 1
    
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s[i - 1] == t[j - 1]:
                # Match: can take (match) or skip (don't match)
                dp[i][j] = dp[i - 1][j - 1] + dp[i - 1][j]
            else:
                # No match: must skip
                dp[i][j] = dp[i - 1][j]
    
    print(f"\n✓ Distinct subsequences: {dp[m][n]}")
    return dp[m][n]

# ============================================================================
# REGULAR EXPRESSION MATCHING
# ============================================================================

def is_match(s, p):
    """
    Regular Expression Matching: '.' matches any char, '*' matches zero or more of preceding
    
    dp[i][j] = does s[0:i] match p[0:j]?
    """
    m, n = len(s), len(p)
    dp = [[False] * (n + 1) for _ in range(m + 1)]
    
    # Empty string matches empty pattern
    dp[0][0] = True
    
    # Handle patterns like a*, a*b*, a*b*c*
    for j in range(2, n + 1):
        if p[j - 1] == '*':
            dp[0][j] = dp[0][j - 2]
    
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if p[j - 1] == '.' or p[j - 1] == s[i - 1]:
                dp[i][j] = dp[i - 1][j - 1]
            elif p[j - 1] == '*':
                # Zero occurrences
                dp[i][j] = dp[i][j - 2]
                # One or more occurrences
                if p[j - 2] == '.' or p[j - 2] == s[i - 1]:
                    dp[i][j] = dp[i][j] or dp[i - 1][j]
    
    return dp[m][n]

# ============================================================================
# EXAMPLE 1: Longest Palindromic Subsequence
# ============================================================================

print("=" * 70)
print("Example 1: Longest Palindromic Subsequence")
print("=" * 70)

s1 = "bbbab"
longest_palindromic_subsequence(s1)

# ============================================================================
# EXAMPLE 2: Longest Palindromic Substring
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Longest Palindromic Substring")
print("=" * 70)

s2 = "babad"
longest_palindromic_substring(s2)

# ============================================================================
# EXAMPLE 3: Word Break
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Word Break")
print("=" * 70)

s3 = "leetcode"
word_dict = {"leet", "code"}
word_break(s3, word_dict)

# ============================================================================
# EXAMPLE 4: Distinct Subsequences
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Distinct Subsequences")
print("=" * 70)

s4 = "rabbbit"
t4 = "rabbit"
num_distinct_subsequences(s4, t4)

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Problem':<35} {'Time':<25} {'Space'}")
print("─" * 85)
print(f"{'LPS (Subsequence)':<35} {'O(n²)':<25} {'O(n²)'}")
print(f"{'LPS (Substring)':<35} {'O(n²)':<25} {'O(n²)'}")
print(f"{'Word Break':<35} {'O(n²)':<25} {'O(n)'}")
print(f"{'Edit Distance':<35} {'O(m × n)':<25} {'O(m × n)'}")
print(f"{'Distinct Subsequences':<35} {'O(m × n)':<25} {'O(m × n)'}")
print(f"{'Regex Matching':<35} {'O(m × n)':<25} {'O(m × n)'}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ DP on strings often uses 2D table dp[i][j]")
print("✓ Common patterns: palindrome, matching, subsequence")
print("✓ LPS: dp[i][j] = dp[i+1][j-1] + 2 if match, else max of neighbors")
print("✓ Word Break: dp[i] = can segment s[0:i]?")
print("✓ Think: What does dp[i][j] represent for substring s[i:j]?")
print("✓ Many string DP problems are variations of LCS or edit distance")
