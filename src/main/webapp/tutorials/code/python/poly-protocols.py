# Polymorphism with Protocols

print("=== Python Protocols ===\n")

# 1. Protocols are informal interfaces
print("1. Common Python protocols:")
print("""
   Protocol        Method(s) needed
   --------        ----------------
   Iterable        __iter__()
   Iterator        __iter__(), __next__()
   Sized           __len__()
   Container       __contains__()
   Callable        __call__()
   Comparable      __lt__(), __eq__(), etc.
""")

# 2. Making objects work with len()
print("2. Sized protocol - work with len():")

class Playlist:
    def __init__(self, name):
        self.name = name
        self.songs = []

    def add(self, song):
        self.songs.append(song)

    def __len__(self):
        """Makes len(playlist) work."""
        return len(self.songs)

playlist = Playlist("My Mix")
playlist.add("Song 1")
playlist.add("Song 2")
playlist.add("Song 3")

print(f"   Playlist has {len(playlist)} songs")  # Works!
print()

# 3. Making objects iterable
print("3. Iterable protocol - work with for loops:")

class Countdown:
    def __init__(self, start):
        self.start = start

    def __iter__(self):
        """Makes object iterable."""
        self.current = self.start
        return self

    def __next__(self):
        """Returns next value."""
        if self.current <= 0:
            raise StopIteration
        value = self.current
        self.current -= 1
        return value

print("   Countdown from 5:", end=" ")
for num in Countdown(5):
    print(num, end=" ")
print()
print()

# 4. Making objects work with 'in'
print("4. Container protocol - work with 'in' operator:")

class NumberRange:
    def __init__(self, start, end):
        self.start = start
        self.end = end

    def __contains__(self, value):
        """Makes 'in' operator work."""
        return self.start <= value <= self.end

    def __len__(self):
        return self.end - self.start + 1

r = NumberRange(1, 100)
print(f"   50 in NumberRange(1, 100): {50 in r}")
print(f"   150 in NumberRange(1, 100): {150 in r}")
print()

# 5. Callable protocol
print("5. Callable protocol - objects as functions:")

class Multiplier:
    def __init__(self, factor):
        self.factor = factor

    def __call__(self, value):
        """Makes object callable like a function."""
        return value * self.factor

double = Multiplier(2)
triple = Multiplier(3)

print(f"   double(5) = {double(5)}")  # Use like a function!
print(f"   triple(5) = {triple(5)}")
print()

# 6. Combining protocols
print("6. Combining multiple protocols:")

class ShoppingCart:
    """Implements multiple protocols."""

    def __init__(self):
        self.items = []

    def add(self, item, price):
        self.items.append((item, price))

    # Sized protocol
    def __len__(self):
        return len(self.items)

    # Container protocol
    def __contains__(self, item):
        return any(i[0] == item for i in self.items)

    # Iterable protocol
    def __iter__(self):
        return iter(self.items)

    # String representation
    def __str__(self):
        return f"Cart with {len(self)} items"

cart = ShoppingCart()
cart.add("Apple", 1.00)
cart.add("Banana", 0.50)
cart.add("Orange", 0.75)

print(f"   Cart: {cart}")
print(f"   Length: {len(cart)}")
print(f"   'Apple' in cart: {'Apple' in cart}")
print(f"   'Grape' in cart: {'Grape' in cart}")
print("   Items:")
for item, price in cart:
    print(f"      {item}: ${price:.2f}")
