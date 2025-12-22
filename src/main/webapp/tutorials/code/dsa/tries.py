"""
Tries (Prefix Trees)
Efficient string search and prefix matching
"""

# ============================================================================
# TRIE NODE
# ============================================================================

class TrieNode:
    """Node in a Trie"""
    
    def __init__(self):
        # Children: dictionary mapping char -> TrieNode
        self.children = {}
        # Is this the end of a word?
        self.is_end_of_word = False
        # Optional: store word count or other data
        self.word_count = 0

# ============================================================================
# TRIE (PREFIX TREE)
# ============================================================================

class Trie:
    """
    Trie - Prefix Tree for efficient string operations
    Perfect for: autocomplete, spell check, prefix matching
    """
    
    def __init__(self):
        self.root = TrieNode()
    
    def insert(self, word):
        """
        Insert word into trie
        Time: O(m) where m = word length
        Space: O(m) worst case
        """
        print(f"\n➕ Inserting '{word}'")
        
        node = self.root
        
        for char in word:
            if char not in node.children:
                print(f"   Creating node for '{char}'")
                node.children[char] = TrieNode()
            else:
                print(f"   Node for '{char}' exists")
            
            node = node.children[char]
        
        node.is_end_of_word = True
        node.word_count += 1
        print(f"   Marked end of word")
    
    def search(self, word):
        """
        Search for exact word
        Time: O(m)
        """
        print(f"\n🔍 Searching for '{word}'")
        
        node = self.root
        
        for char in word:
            if char not in node.children:
                print(f"   '{char}' not found - word doesn't exist")
                return False
            node = node.children[char]
        
        found = node.is_end_of_word
        print(f"   {'✓ Found!' if found else '✗ Not a complete word'}")
        return found
    
    def starts_with(self, prefix):
        """
        Check if any word starts with prefix
        Time: O(m)
        """
        print(f"\n🔎 Checking prefix '{prefix}'")
        
        node = self.root
        
        for char in prefix:
            if char not in node.children:
                print(f"   No words with this prefix")
                return False
            node = node.children[char]
        
        print(f"   ✓ Prefix exists!")
        return True
    
    def get_all_words_with_prefix(self, prefix):
        """
        Get all words starting with prefix
        Real-world: Autocomplete suggestions
        """
        print(f"\n📝 Finding all words with prefix '{prefix}'")
        
        # Navigate to prefix node
        node = self.root
        for char in prefix:
            if char not in node.children:
                return []
            node = node.children[char]
        
        # Collect all words from this node
        words = []
        self._collect_words(node, prefix, words)
        
        print(f"   Found: {words}")
        return words
    
    def _collect_words(self, node, current_word, words):
        """Helper to collect all words from a node"""
        if node.is_end_of_word:
            words.append(current_word)
        
        for char, child_node in node.children.items():
            self._collect_words(child_node, current_word + char, words)
    
    def delete(self, word):
        """
        Delete word from trie
        Time: O(m)
        """
        print(f"\n🗑️ Deleting '{word}'")
        
        def _delete_helper(node, word, index):
            if index == len(word):
                # Reached end of word
                if not node.is_end_of_word:
                    return False  # Word doesn't exist
                
                node.is_end_of_word = False
                # Delete node if it has no children
                return len(node.children) == 0
            
            char = word[index]
            if char not in node.children:
                return False  # Word doesn't exist
            
            child_node = node.children[char]
            should_delete_child = _delete_helper(child_node, word, index + 1)
            
            if should_delete_child:
                del node.children[char]
                # Delete current node if it's not end of another word
                return not node.is_end_of_word and len(node.children) == 0
            
            return False
        
        _delete_helper(self.root, word, 0)
        print(f"   Deleted '{word}'")
    
    def count_words_with_prefix(self, prefix):
        """Count words with given prefix"""
        node = self.root
        
        for char in prefix:
            if char not in node.children:
                return 0
            node = node.children[char]
        
        count = [0]
        
        def _count(node):
            if node.is_end_of_word:
                count[0] += 1
            for child in node.children.values():
                _count(child)
        
        _count(node)
        return count[0]

# ============================================================================
# APPLICATION 1: AUTOCOMPLETE SYSTEM
# ============================================================================

class AutocompleteSystem:
    """
    Autocomplete system using Trie
    Real-world: Search engines, IDEs, mobile keyboards
    """
    
    def __init__(self):
        self.trie = Trie()
    
    def add_word(self, word):
        """Add word to dictionary"""
        self.trie.insert(word.lower())
    
    def get_suggestions(self, prefix, max_suggestions=5):
        """Get autocomplete suggestions"""
        prefix = prefix.lower()
        all_words = self.trie.get_all_words_with_prefix(prefix)
        return all_words[:max_suggestions]

# ============================================================================
# APPLICATION 2: SPELL CHECKER
# ============================================================================

class SpellChecker:
    """
    Simple spell checker using Trie
    Real-world: Word processors, text editors
    """
    
    def __init__(self, dictionary):
        self.trie = Trie()
        for word in dictionary:
            self.trie.insert(word.lower())
    
    def is_correct(self, word):
        """Check if word is spelled correctly"""
        return self.trie.search(word.lower())
    
    def suggest_corrections(self, word):
        """Suggest corrections for misspelled word"""
        word = word.lower()
        suggestions = []
        
        # Try removing one character
        for i in range(len(word)):
            candidate = word[:i] + word[i+1:]
            if self.trie.search(candidate):
                suggestions.append(candidate)
        
        # Try replacing one character
        for i in range(len(word)):
            for c in 'abcdefghijklmnopqrstuvwxyz':
                candidate = word[:i] + c + word[i+1:]
                if self.trie.search(candidate):
                    suggestions.append(candidate)
        
        return list(set(suggestions))[:5]

# ============================================================================
# APPLICATION 3: WORD SEARCH IN GRID
# ============================================================================

def find_words_in_grid(board, words):
    """
    Find all words from list that exist in 2D board
    Real-world: Word games (Boggle, Word Search)
    Time: O(m * n * 4^L) where L = max word length
    """
    print(f"\n🎮 Finding words in grid")
    
    # Build trie of words
    trie = Trie()
    for word in words:
        trie.insert(word)
    
    found_words = set()
    rows, cols = len(board), len(board[0])
    
    def dfs(i, j, node, path):
        if node.is_end_of_word:
            found_words.add(path)
        
        if i < 0 or i >= rows or j < 0 or j >= cols:
            return
        
        char = board[i][j]
        if char not in node.children:
            return
        
        # Mark visited
        board[i][j] = '#'
        
        # Explore all 4 directions
        for di, dj in [(0,1), (1,0), (0,-1), (-1,0)]:
            dfs(i + di, j + dj, node.children[char], path + char)
        
        # Restore
        board[i][j] = char
    
    # Try starting from each cell
    for i in range(rows):
        for j in range(cols):
            dfs(i, j, trie.root, "")
    
    print(f"   Found words: {found_words}")
    return list(found_words)

# ============================================================================
# EXAMPLES
# ============================================================================

print("=" * 70)
print("Trie (Prefix Tree) Examples")
print("=" * 70)

# Example 1: Basic Trie Operations
print("\n" + "=" * 70)
print("Example 1: Basic Trie Operations")
print("=" * 70)

trie = Trie()

# Insert words
words = ["apple", "app", "application", "apply", "banana"]
for word in words:
    trie.insert(word)

# Search
trie.search("app")       # True
trie.search("appl")      # False (not a complete word)

# Prefix search
trie.starts_with("app")  # True
trie.starts_with("ban")  # True
trie.starts_with("cat")  # False

# Get all words with prefix
trie.get_all_words_with_prefix("app")

# Example 2: Autocomplete System
print("\n" + "=" * 70)
print("Example 2: Autocomplete System")
print("=" * 70)

autocomplete = AutocompleteSystem()

# Add words
words = ["apple", "application", "apply", "appreciate", "approach", "banana"]
for word in words:
    autocomplete.add_word(word)

# Get suggestions
print("\nAutocomplete for 'app':")
suggestions = autocomplete.get_suggestions("app")
print(f"  Suggestions: {suggestions}")

print("\nAutocomplete for 'appr':")
suggestions = autocomplete.get_suggestions("appr")
print(f"  Suggestions: {suggestions}")

# Example 3: Spell Checker
print("\n" + "=" * 70)
print("Example 3: Spell Checker")
print("=" * 70)

dictionary = ["hello", "world", "python", "programming", "code"]
spell_checker = SpellChecker(dictionary)

print("\nChecking 'hello':", spell_checker.is_correct("hello"))
print("Checking 'helo':", spell_checker.is_correct("helo"))

print("\nSuggestions for 'helo':", spell_checker.suggest_corrections("helo"))
print("Suggestions for 'wrld':", spell_checker.suggest_corrections("wrld"))

# Example 4: Word Count
print("\n" + "=" * 70)
print("Example 4: Count Words with Prefix")
print("=" * 70)

trie2 = Trie()
words = ["apple", "app", "application", "apply", "banana", "band"]
for word in words:
    trie2.insert(word)

print(f"\nWords starting with 'app': {trie2.count_words_with_prefix('app')}")
print(f"Words starting with 'ban': {trie2.count_words_with_prefix('ban')}")
print(f"Words starting with 'cat': {trie2.count_words_with_prefix('cat')}")

# ============================================================================
# COMPLEXITY SUMMARY
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Summary")
print("=" * 70)

print(f"\n{'Operation':<25} {'Time':<20} {'Space':<20}")
print("─" * 65)
print(f"{'Insert word':<25} {'O(m)':<20} {'O(m)':<20}")
print(f"{'Search word':<25} {'O(m)':<20} {'O(1)':<20}")
print(f"{'Prefix search':<25} {'O(m)':<20} {'O(1)':<20}")
print(f"{'Delete word':<25} {'O(m)':<20} {'O(1)':<20}")
print(f"{'Autocomplete':<25} {'O(m + n)':<20} {'O(n)':<20}")

print("\nWhere:")
print("  m = length of word/prefix")
print("  n = number of words with prefix")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Trie = tree where each path represents a word")
print("✓ Each node has children map (char → node)")
print("✓ Perfect for prefix-based operations")
print("✓ Space: O(ALPHABET_SIZE * N * M) worst case")
print("✓ Better than hash table for prefix queries")
print("✓ Used in: autocomplete, spell check, IP routing")
print("✓ Trade-off: More space for faster prefix operations")
