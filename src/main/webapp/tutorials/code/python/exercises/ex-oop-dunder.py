# Exercise: Dunder Methods
# Task: Implement __str__ for a Book class.

class Book:
    def __init__(self, title, author):
        self.title = title
        self.author = author

    # 1. Implement __str__ to return "Title by Author"
    # Your code here:


b = Book("1984", "George Orwell")

# 2. Print the object
print(b)
