# Exception Class Hierarchy

print("=== Python Exception Hierarchy ===\n")

# All exceptions inherit from BaseException
# Most exceptions inherit from Exception

print("""
BaseException (root of all exceptions)
├── SystemExit          - sys.exit() called
├── KeyboardInterrupt   - Ctrl+C pressed
├── GeneratorExit       - Generator closed
└── Exception           - All other exceptions
    ├── StopIteration
    ├── ArithmeticError
    │   ├── ZeroDivisionError
    │   ├── OverflowError
    │   └── FloatingPointError
    ├── LookupError
    │   ├── IndexError
    │   └── KeyError
    ├── OSError
    │   ├── FileNotFoundError
    │   ├── PermissionError
    │   └── TimeoutError
    ├── ValueError
    ├── TypeError
    ├── AttributeError
    └── RuntimeError
""")

# Demonstrate hierarchy with isinstance
print("=== Hierarchy Demo ===\n")

errors = [
    ZeroDivisionError("division by zero"),
    IndexError("list index out of range"),
    FileNotFoundError("file.txt"),
    ValueError("invalid literal"),
]

for error in errors:
    print(f"{type(error).__name__}:")
    print(f"  Is Exception? {isinstance(error, Exception)}")
    print(f"  Is ArithmeticError? {isinstance(error, ArithmeticError)}")
    print(f"  Is LookupError? {isinstance(error, LookupError)}")
    print(f"  Is OSError? {isinstance(error, OSError)}")
    print()

# Catching parent classes
print("=== Catching Parent Classes ===\n")

# Catching LookupError catches both IndexError and KeyError
print("Catching LookupError (parent):")
for error_code in [lambda: [1][5], lambda: {}["x"]]:
    try:
        error_code()
    except LookupError as e:
        print(f"  Caught: {type(e).__name__}: {e}")
print()

# Why this matters
print("=== Why Hierarchy Matters ===")
print("""
1. Catch specific first, general later:
   try:
       risky_code()
   except FileNotFoundError:
       # Handle missing file specifically
   except OSError:
       # Handle other OS errors

2. Catch all exceptions (careful!):
   except Exception:
       # Don't catch BaseException!
       # Let KeyboardInterrupt propagate

3. Check exception type:
   isinstance(e, LookupError)
""")
