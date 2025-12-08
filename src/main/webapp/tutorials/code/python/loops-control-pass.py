# The pass Statement - Do Nothing Placeholder

# Pass as placeholder in empty loop
print("=== Pass as Placeholder ===")

# When you need a loop but haven't written the code yet
for i in range(3):
    pass  # TODO: implement later
print("Loop completed (did nothing)")

print()

# Pass in conditional
print("=== Pass in Conditional ===")
for i in range(5):
    if i == 2:
        pass  # Intentionally do nothing for 2
        print(f"  (pass executed for {i})")
    else:
        print(f"Processing {i}")

print()

# Pass vs continue - they're different!
print("=== Pass vs Continue ===")
print("With pass:")
for i in range(3):
    if i == 1:
        pass
    print(f"  i = {i}")  # ALL values print

print("\nWith continue:")
for i in range(3):
    if i == 1:
        continue
    print(f"  i = {i}")  # 1 is skipped!

print()

# Common use: Empty class or function
print("=== Pass in Definitions ===")
print("""
# Empty class placeholder
class MyClass:
    pass

# Empty function placeholder
def my_function():
    pass

# Empty conditional branch
if condition:
    do_something()
else:
    pass  # Nothing to do in else case
""")
