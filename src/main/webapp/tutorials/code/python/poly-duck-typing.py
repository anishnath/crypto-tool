# Duck Typing

print("=== Duck Typing ===\n")

# 1. "If it walks like a duck and quacks like a duck..."
print("1. Duck typing principle:")
print('   "If it looks like a duck and quacks like a duck, it\'s a duck"')
print()

# No need for inheritance - just have the right methods!
class Duck:
    def quack(self):
        return "Quack quack!"

    def walk(self):
        return "Waddle waddle"

class Person:
    def quack(self):
        return "I'm pretending to quack!"

    def walk(self):
        return "Walking on two legs"

class Robot:
    def quack(self):
        return "QUACK.EXE RUNNING"

    def walk(self):
        return "Beep boop walking"

def make_it_act_like_duck(thing):
    """Doesn't check type - just uses the methods."""
    print(f"   {thing.__class__.__name__}:")
    print(f"      {thing.quack()}")
    print(f"      {thing.walk()}")

# All work because they have quack() and walk()
for thing in [Duck(), Person(), Robot()]:
    make_it_act_like_duck(thing)
print()

# 2. Duck typing vs type checking
print("2. Duck typing vs explicit type checking:")

# Bad - too restrictive
def bad_process_duck(duck):
    if isinstance(duck, Duck):  # Only works with Duck class!
        return duck.quack()
    raise TypeError("Must be a Duck!")

# Good - duck typing
def good_process_duck(duck):
    return duck.quack()  # Works with anything that can quack

print(f"   Good approach works with Person: {good_process_duck(Person())}")
print()

# 3. Real-world duck typing examples
print("3. Real-world examples:")

# File-like objects
class StringReader:
    """Not a file, but acts like one for reading."""
    def __init__(self, text):
        self.text = text
        self.pos = 0

    def read(self, n=-1):
        if n < 0:
            result = self.text[self.pos:]
            self.pos = len(self.text)
        else:
            result = self.text[self.pos:self.pos+n]
            self.pos += n
        return result

    def readline(self):
        newline_pos = self.text.find('\n', self.pos)
        if newline_pos == -1:
            return self.read()
        result = self.text[self.pos:newline_pos+1]
        self.pos = newline_pos + 1
        return result

def process_file_like(f):
    """Works with any file-like object."""
    return f.readline().strip()

reader = StringReader("Hello\nWorld\n")
print(f"   StringReader: {process_file_like(reader)}")
print()

# 4. EAFP vs LBYL
print("4. EAFP vs LBYL (Python's preferred style):")

# LBYL: Look Before You Leap (less Pythonic)
def calculate_lbyl(obj):
    if hasattr(obj, 'calculate'):
        return obj.calculate()
    else:
        return "Can't calculate"

# EAFP: Easier to Ask Forgiveness than Permission (Pythonic)
def calculate_eafp(obj):
    try:
        return obj.calculate()
    except AttributeError:
        return "Can't calculate"

class Calculator:
    def calculate(self):
        return 42

class NotCalculator:
    pass

print(f"   EAFP with Calculator: {calculate_eafp(Calculator())}")
print(f"   EAFP with NotCalculator: {calculate_eafp(NotCalculator())}")
print()

# 5. Duck typing best practices
print("5. Best practices:")
print("""
   DO:
   - Trust objects have the methods you need
   - Use try/except for error handling
   - Document expected interface in docstrings

   DON'T:
   - Use isinstance() to check types (usually)
   - Require specific class inheritance
   - Over-specify parameter types

   Duck typing makes Python flexible and powerful!
""")
