# Practical Return Patterns

# 1. Early return for validation
print("=== Early Return Pattern ===")
def divide(a, b):
    """Divide a by b with error handling."""
    if b == 0:
        return None  # Early return for error
    return a / b

print(f"10 / 2 = {divide(10, 2)}")
print(f"10 / 0 = {divide(10, 0)}")
print()

# 2. Guard clauses
print("=== Guard Clauses ===")
def process_order(order):
    """Process an order with validation."""
    if not order:
        return {"error": "No order provided"}
    if "items" not in order:
        return {"error": "Order has no items"}
    if len(order["items"]) == 0:
        return {"error": "Order is empty"}

    # Main logic after all guards pass
    total = sum(item["price"] for item in order["items"])
    return {"success": True, "total": total}

print(process_order(None))
print(process_order({}))
print(process_order({"items": []}))
print(process_order({"items": [{"price": 10}, {"price": 20}]}))
print()

# 3. Factory functions
print("=== Factory Pattern ===")
def create_user(username, role="user"):
    """Create a user dictionary."""
    return {
        "username": username,
        "role": role,
        "active": True,
        "permissions": ["read"] if role == "user" else ["read", "write", "admin"]
    }

user = create_user("alice")
admin = create_user("bob", role="admin")
print(f"User: {user}")
print(f"Admin: {admin}")
print()

# 4. Conditional return types
print("=== Result Pattern ===")
def parse_int(s):
    """Parse string to int, return tuple (success, value/error)."""
    try:
        return True, int(s)
    except ValueError as e:
        return False, str(e)

success, value = parse_int("123")
print(f"'123': success={success}, value={value}")

success, value = parse_int("abc")
print(f"'abc': success={success}, value={value}")
