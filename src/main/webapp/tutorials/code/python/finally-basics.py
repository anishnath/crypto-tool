# Finally Block Basics

print("=== Finally Block Basics ===\n")

# 1. Finally always runs - with exception
print("1. Finally runs even when exception occurs:")
try:
    print("   Try: About to raise exception")
    raise ValueError("Something went wrong")
except ValueError as e:
    print(f"   Except: Caught {e}")
finally:
    print("   Finally: This ALWAYS runs!")
print()

# 2. Finally always runs - without exception
print("2. Finally runs when no exception:")
try:
    print("   Try: No exception here")
    result = 10 + 5
    print(f"   Try: Result = {result}")
except ValueError:
    print("   Except: This won't run")
finally:
    print("   Finally: Still runs!")
print()

# 3. Finally runs even if except re-raises
print("3. Finally runs even when re-raising:")
try:
    try:
        raise RuntimeError("Original error")
    except RuntimeError:
        print("   Except: Catching and re-raising")
        raise  # Re-raise the exception
    finally:
        print("   Finally: Runs before exception propagates!")
except RuntimeError:
    print("   Outer: Caught the re-raised exception")
print()

# 4. Finally runs even with return
print("4. Finally runs even with return:")

def returns_early():
    try:
        print("   Try: About to return")
        return "returned value"
    finally:
        print("   Finally: Runs BEFORE return completes!")

result = returns_early()
print(f"   Got: {result}")
print()

# 5. Finally runs even with break in loops
print("5. Finally runs even with break:")
for i in range(3):
    try:
        if i == 1:
            print(f"   Try: Breaking at i={i}")
            break
        print(f"   Try: i={i}")
    finally:
        print(f"   Finally: i={i}")
print()

# 6. Order of execution
print("6. Execution order: try -> except/else -> finally")
print("   (See next section for else clause)")
