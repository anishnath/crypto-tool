# Assert Messages and Debugging

print("=== Assert Messages ===\n")

# 1. Always include a message
print("1. Assert with helpful message:")

def divide(a, b):
    assert b != 0, f"Cannot divide by zero (a={a}, b={b})"
    return a / b

try:
    divide(10, 0)
except AssertionError as e:
    print(f"   {e}")
print()

# 2. Include variable values in message
print("2. Include context in messages:")

def process_age(age):
    assert isinstance(age, int), f"Age must be int, got {type(age).__name__}"
    assert 0 <= age <= 150, f"Age {age} out of valid range [0, 150]"
    return f"Valid age: {age}"

test_values = ["twenty", -5, 200, 25]
for val in test_values:
    try:
        result = process_age(val)
        print(f"   {val!r:10} -> {result}")
    except AssertionError as e:
        print(f"   {val!r:10} -> AssertionError: {e}")
print()

# 3. Avoid expensive message computation
print("3. Message is only evaluated on failure:")

call_count = 0
def expensive_message():
    global call_count
    call_count += 1
    return f"Expensive computation #{call_count}"

# Message not evaluated when assertion passes
x = 10
assert x > 0, expensive_message()  # Message NOT computed
assert x > 0, expensive_message()  # Message NOT computed
assert x > 0, expensive_message()  # Message NOT computed

print(f"   3 passing asserts, expensive_message called: {call_count} times")

# Only computed on failure
try:
    assert x < 0, expensive_message()  # Message IS computed
except AssertionError:
    pass

print(f"   After 1 failing assert, expensive_message called: {call_count} times")
print()

# 4. Good vs bad messages
print("4. Good vs bad assertion messages:")
print("""
# BAD - no information
assert x > 0

# BAD - just restates condition
assert x > 0, "x must be greater than zero"

# GOOD - includes actual value
assert x > 0, f"x must be positive, got {x}"

# GOOD - includes context
assert user_id in users, f"User {user_id} not found in {len(users)} users"

# GOOD - explains what went wrong
assert response.status == 200, f"API failed: {response.status} {response.body}"
""")

# 5. Practical example with detailed message
print("5. Practical example:")

def validate_config(config):
    assert isinstance(config, dict), \
        f"Config must be dict, got {type(config).__name__}"

    required = ['host', 'port', 'timeout']
    missing = [k for k in required if k not in config]
    assert not missing, \
        f"Missing required config keys: {missing}"

    assert isinstance(config['port'], int), \
        f"Port must be int, got {type(config['port']).__name__}: {config['port']}"

    assert 1 <= config['port'] <= 65535, \
        f"Port {config['port']} not in valid range [1, 65535]"

    return True

configs = [
    "not a dict",
    {'host': 'localhost'},
    {'host': 'localhost', 'port': '80', 'timeout': 30},
    {'host': 'localhost', 'port': 99999, 'timeout': 30},
    {'host': 'localhost', 'port': 8080, 'timeout': 30},
]

for config in configs:
    try:
        validate_config(config)
        print(f"   Valid: {config}")
    except AssertionError as e:
        print(f"   Invalid: {e}")
