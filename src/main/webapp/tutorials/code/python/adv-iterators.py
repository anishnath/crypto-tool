# Python Iterators
# An iterator is an object that contains a countable number of values.
# An iterator is an object that can be iterated upon, meaning that you can traverse through all the values.
# Technically, in Python, an iterator is an object which implements the iterator protocol, which consist of the methods __iter__() and __next__().

# 1. Iterator vs Iterable
# Lists, tuples, dictionaries, and sets are all iterable objects. They are iterable containers which you can get an iterator from.

mytuple = ("apple", "banana", "cherry")
myit = iter(mytuple)

print(next(myit))
print(next(myit))
print(next(myit))

# 2. Looping Through an Iterator
# We can also use a for loop to iterate through an iterable object:
# The for loop actually creates an iterator object and executes the next() method for each loop.

mytuple = ("apple", "banana", "cherry")

for x in mytuple:
  print(x)

# 3. Create an Iterator
# To create an object/class as an iterator you have to implement the methods __iter__() and __next__() to your object.

class MyNumbers:
  def __iter__(self):
    self.a = 1
    return self

  def __next__(self):
    if self.a <= 5:
      x = self.a
      self.a += 1
      return x
    else:
      raise StopIteration

myclass = MyNumbers()
myiter = iter(myclass)

print(next(myiter))
print(next(myiter))
print(next(myiter))
print(next(myiter))
print(next(myiter))

# 4. StopIteration
# To prevent the iteration to go on forever, we use the StopIteration statement.
