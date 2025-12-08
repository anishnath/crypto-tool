# Finally with Return Statements

print("=== Finally with Return ===\n")

# 1. Return in try, finally runs first
print("1. Return in try block:")

def try_return():
    try:
        print("   Try: Returning 'from try'")
        return "from try"
    finally:
        print("   Finally: Executing before return")

result = try_return()
print(f"   Result: {result}")
print()

# 2. Return in finally OVERRIDES try's return
print("2. Return in finally overrides try:")

def finally_overrides():
    try:
        print("   Try: Returning 'from try'")
        return "from try"
    finally:
        print("   Finally: Returning 'from finally' instead!")
        return "from finally"  # This wins!

result = finally_overrides()
print(f"   Result: {result}")  # "from finally"!
print()

# 3. Return in finally suppresses exception!
print("3. Return in finally suppresses exception:")

def finally_suppresses_exception():
    try:
        print("   Try: Raising ValueError")
        raise ValueError("This will be suppressed!")
    finally:
        print("   Finally: Returning instead of propagating")
        return "exception was suppressed"

result = finally_suppresses_exception()
print(f"   Result: {result}")  # No exception raised!
print()

# 4. Modifying return value in finally - DOESN'T work
print("4. Modifying return value in finally (doesn't work):")

def try_modify_return():
    result = "original"
    try:
        result = "from try"
        return result
    finally:
        # This modification doesn't affect the return!
        result = "modified in finally"
        print(f"   Finally: Set result to '{result}'")

actual = try_modify_return()
print(f"   Actual return: '{actual}'")  # Still "from try"
print()

# 5. Best practice: avoid return in finally
print("5. Best practice - avoid return in finally:")

def proper_cleanup():
    resource = None
    try:
        resource = "acquired resource"
        # Do work...
        return "success"
    except Exception as e:
        return f"error: {e}"
    finally:
        # Cleanup only, no return!
        if resource:
            print(f"   Finally: Cleaning up {resource}")

result = proper_cleanup()
print(f"   Result: {result}")
print()

# 6. Warning summary
print("=== Warning ===")
print("""
Avoid these patterns in finally:
- return (overrides try's return)
- raise (replaces original exception)
- break/continue in loops

Finally should only do cleanup!
""")
