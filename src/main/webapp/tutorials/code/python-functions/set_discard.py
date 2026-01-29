
fruits = {"apple", "banana", "cherry"}

# Remove "banana"
fruits.discard("banana")
print(f"After discard: {fruits}")

# Try to discard item that doesn't exist (no error)
fruits.discard("orange")
print(f"After invalid discard: {fruits}")
