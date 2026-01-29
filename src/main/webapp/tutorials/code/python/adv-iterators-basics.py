# Iterables vs Iterators

# Iterables: objects you can iterate over
my_list = [1, 2, 3, 4, 5]
my_tuple = ("a", "b", "c")
my_string = "hello"

# You can get an iterator from any iterable using iter()
list_iter = iter(my_list)
tuple_iter = iter(my_tuple)
string_iter = iter(my_string)

# Iterators: objects that produce values one at a time
print("List iterator:")
print(next(list_iter))  # 1
print(next(list_iter))  # 2
print(next(list_iter))  # 3

print("\nTuple iterator:")
print(next(tuple_iter))  # 'a'
print(next(tuple_iter))  # 'b'

print("\nString iterator:")
print(next(string_iter))  # 'h'
print(next(string_iter))  # 'e'

# Iterators are iterables too (they have __iter__ that returns self)
# But iterables are NOT necessarily iterators until converted
print("\nIterator is iterable:")
print(hasattr(list_iter, '__iter__'))  # True
print(hasattr(list_iter, '__next__'))  # True
print(hasattr(my_list, '__iter__'))    # True
print(hasattr(my_list, '__next__'))    # False - list is NOT an iterator

# for loops automatically create iterators
print("\nUsing for loop (automatic iteration):")
for item in my_list:
    print(item)





