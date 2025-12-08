# Container Methods: __len__, __getitem__, __iter__, etc.

print("=== Container Methods ===\n")

# 1. __len__ - length
print("1. __len__ - make len() work:")

class Playlist:
    def __init__(self, name):
        self.name = name
        self.songs = []

    def add(self, song):
        self.songs.append(song)

    def __len__(self):
        return len(self.songs)

playlist = Playlist("My Mix")
playlist.add("Song 1")
playlist.add("Song 2")
playlist.add("Song 3")

print(f"   len(playlist): {len(playlist)}")
print(f"   bool(playlist): {bool(playlist)}")  # True if len > 0
print()

# 2. __getitem__ - indexing
print("2. __getitem__ - indexing and slicing:")

class Sentence:
    def __init__(self, text):
        self.words = text.split()

    def __getitem__(self, index):
        """sentence[0], sentence[1:3], etc."""
        return self.words[index]

    def __len__(self):
        return len(self.words)

s = Sentence("Hello World from Python")
print(f"   s[0]: {s[0]}")
print(f"   s[-1]: {s[-1]}")
print(f"   s[1:3]: {s[1:3]}")  # Slicing works too!
print()

# 3. __setitem__ and __delitem__
print("3. __setitem__ and __delitem__ - assignment and deletion:")

class MyList:
    def __init__(self):
        self._data = []

    def __getitem__(self, index):
        return self._data[index]

    def __setitem__(self, index, value):
        """mylist[0] = 'x'"""
        self._data[index] = value

    def __delitem__(self, index):
        """del mylist[0]"""
        del self._data[index]

    def __len__(self):
        return len(self._data)

    def append(self, value):
        self._data.append(value)

    def __repr__(self):
        return f"MyList({self._data})"

ml = MyList()
ml.append(1)
ml.append(2)
ml.append(3)
print(f"   Initial: {ml}")
ml[1] = 99
print(f"   After ml[1] = 99: {ml}")
del ml[0]
print(f"   After del ml[0]: {ml}")
print()

# 4. __contains__ - membership testing
print("4. __contains__ - the 'in' operator:")

class Group:
    def __init__(self, members):
        self.members = set(members)

    def __contains__(self, person):
        """person in group"""
        return person in self.members

team = Group(["Alice", "Bob", "Carol"])
print(f"   'Alice' in team: {'Alice' in team}")
print(f"   'David' in team: {'David' in team}")
print()

# 5. __iter__ and __next__ - iteration
print("5. __iter__ - make object iterable:")

class Countdown:
    def __init__(self, start):
        self.start = start

    def __iter__(self):
        """Return an iterator object."""
        self.current = self.start
        return self

    def __next__(self):
        """Return next value."""
        if self.current <= 0:
            raise StopIteration
        value = self.current
        self.current -= 1
        return value

print("   Countdown from 5:", end=" ")
for n in Countdown(5):
    print(n, end=" ")
print()
print()

# 6. Complete example - custom collection
print("6. Complete example - StudentGrades:")

class StudentGrades:
    """A collection that combines multiple container protocols."""

    def __init__(self):
        self._grades = {}

    def add_grade(self, student, grade):
        self._grades[student] = grade

    def __len__(self):
        return len(self._grades)

    def __getitem__(self, student):
        return self._grades[student]

    def __setitem__(self, student, grade):
        self._grades[student] = grade

    def __delitem__(self, student):
        del self._grades[student]

    def __contains__(self, student):
        return student in self._grades

    def __iter__(self):
        return iter(self._grades.items())

    def __repr__(self):
        return f"StudentGrades({dict(self._grades)})"

grades = StudentGrades()
grades.add_grade("Alice", 95)
grades["Bob"] = 87
grades["Carol"] = 92

print(f"   Grades: {grades}")
print(f"   Length: {len(grades)}")
print(f"   Alice's grade: {grades['Alice']}")
print(f"   'Bob' in grades: {'Bob' in grades}")
print("   All grades:")
for student, grade in grades:
    print(f"      {student}: {grade}")
