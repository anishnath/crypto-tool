
# Join list elements
myList = ["John", "Peter", "Vicky"]
x = "#".join(myList)
print(f"List {myList} joined by '#': {x}")

# Join tuple elements
myTuple = ("a", "b", "c")
y = "".join(myTuple)
print(f"Tuple {myTuple} joined by empty string: {y}")

# Join set elements (random order)
mySet = {"apple", "banana", "cherry"}
z = ", ".join(mySet)
print(f"Set {mySet} joined by ', ': {z}")

# Join dictionary keys
myDict = {"name": "John", "country": "Norway"}
w = " AND ".join(myDict)
print(f"Dict {myDict} joined: {w}")
