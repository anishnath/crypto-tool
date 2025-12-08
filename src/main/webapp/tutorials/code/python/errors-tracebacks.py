# Understanding Tracebacks

import traceback

print("=== Reading Tracebacks ===\n")

# A traceback shows:
# 1. Where the error occurred
# 2. The call stack (function calls that led to error)
# 3. The error type and message

def function_a():
    function_b()

def function_b():
    function_c()

def function_c():
    # This will cause an error
    return 1 / 0

# Capture and print a traceback
print("1. Simple Traceback:")
try:
    function_a()
except ZeroDivisionError:
    traceback.print_exc()
print()

# Anatomy of a traceback
print("2. Traceback Anatomy:")
print("""
Traceback (most recent call last):     <- Start reading here
  File "script.py", line 10, in <module>  <- Where it started
    function_a()                           <- What was called
  File "script.py", line 4, in function_a  <- Next function
    function_b()
  File "script.py", line 7, in function_b  <- Goes deeper
    function_c()
  File "script.py", line 11, in function_c <- Where error happened
    return 1 / 0                           <- The problematic line
ZeroDivisionError: division by zero    <- Error type and message

Read BOTTOM to TOP to trace the error!
""")

# Getting traceback info programmatically
print("3. Accessing Traceback Info:")
try:
    x = int("not a number")
except ValueError as e:
    print(f"Error Type: {type(e).__name__}")
    print(f"Error Message: {e}")
    print(f"Args: {e.args}")
print()

# Traceback with line numbers
print("4. Line Number Example:")
def process_data(items):
    total = 0
    for i, item in enumerate(items):
        # Line below will fail on string
        total += item * 2
    return total

try:
    process_data([1, 2, "three", 4])
except TypeError:
    traceback.print_exc()
print()

# Common traceback tips
print("5. Debugging Tips:")
print("""
- Read from BOTTOM up
- The last line shows the error type
- Look for YOUR code files (not library files)
- The arrow (^) points to the exact problem
- Check the line ABOVE for context

Example error messages:
- "name 'x' is not defined" -> Typo or missing variable
- "list index out of range" -> Loop went too far
- "NoneType has no attribute" -> Function returned None
- "takes 2 arguments (1 given)" -> Missing argument
""")
