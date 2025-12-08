# Multiple Except Clauses

print("=== Multiple Except Clauses ===\n")

# 1. Different handlers for different exceptions
print("1. Handling different exception types:")

def process_input(value):
    try:
        number = int(value)
        result = 100 / number
        return result
    except ValueError:
        print(f"   ValueError: '{value}' is not a valid number")
    except ZeroDivisionError:
        print("   ZeroDivisionError: Cannot divide by zero")
    return None

process_input("hello")  # ValueError
process_input("0")      # ZeroDivisionError
result = process_input("5")  # Success
print(f"   Success: {result}")
print()

# 2. Catching multiple exceptions in one clause
print("2. One handler for multiple exceptions:")
try:
    # This could raise either exception
    data = [1, 2, 3]
    value = data[10]  # IndexError
except (IndexError, KeyError):
    print("   Caught IndexError or KeyError")
print()

# 3. Order matters! Specific before general
print("3. Exception order (specific first):")

def divide(a, b):
    try:
        return a / b
    except ZeroDivisionError:
        print("   Specific: Division by zero")
        return None
    except ArithmeticError:
        print("   General: Math error")
        return None

divide(10, 0)  # Matches ZeroDivisionError first
print()

# 4. Catch-all with Exception
print("4. Catch-all (use sparingly!):")
try:
    # Unknown what might fail
    risky = {}["missing"]
except KeyError:
    print("   Specific: Key not found")
except Exception as e:
    print(f"   Catch-all: {type(e).__name__}: {e}")
print()

# 5. Handling exceptions from function calls
print("5. Exceptions from nested functions:")

def step1():
    return int("not a number")

def step2():
    return step1()

def step3():
    return step2()

try:
    step3()
except ValueError:
    print("   Caught ValueError from deep in call stack")
print()

# 6. Pattern: User input validation
print("6. User Input Pattern:")

def get_number(prompt_text="Enter number: "):
    user_input = "42"  # Simulating input
    try:
        return int(user_input)
    except ValueError:
        print(f"   Invalid: '{user_input}' is not a number")
        return None

result = get_number()
print(f"   Got: {result}")
