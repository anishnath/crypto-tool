# Default Parameter Values

# 1. Basic default values
print("=== Basic Defaults ===")
def greet(name, greeting="Hello"):
    """Greet someone with a customizable greeting."""
    print(f"{greeting}, {name}!")

greet("Alice")              # Uses default greeting
greet("Bob", "Hi")          # Overrides default
greet("Charlie", "Hey")
print()

# 2. Multiple defaults
print("=== Multiple Defaults ===")
def make_coffee(size="medium", milk="regular", sugar=1):
    """Order a coffee with customizable options."""
    print(f"{size.title()} coffee, {milk} milk, {sugar} sugar(s)")

make_coffee()                          # All defaults
make_coffee("large")                   # Override first
make_coffee("small", "oat")            # Override first two
make_coffee("large", sugar=0)          # Skip middle parameter
make_coffee(milk="almond", sugar=2)    # Skip first parameter
print()

# 3. Non-default must come before default
print("=== Parameter Order ===")
# Correct: required parameters first, then defaults
def send_email(to_address, subject, body="", priority="normal"):
    print(f"To: {to_address}")
    print(f"Subject: {subject}")
    print(f"Priority: {priority}")

send_email("user@example.com", "Meeting")
send_email("admin@example.com", "Urgent", priority="high")
print()

# This would be a SyntaxError:
# def bad_order(name="default", age):  # Required after default!
#     pass

# 4. Default values are evaluated once
print("=== Default Value Gotcha ===")
# WARNING: Mutable default values are shared!
def add_item_bad(item, items=[]):
    items.append(item)
    return items

# Problem: same list reused
print(add_item_bad("a"))  # ['a']
print(add_item_bad("b"))  # ['a', 'b'] - unexpected!

# Correct pattern: use None
def add_item_good(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items

print(add_item_good("a"))  # ['a']
print(add_item_good("b"))  # ['b'] - correct!
