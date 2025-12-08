# Python PIP
# PIP is a package manager for Python packages, or modules if you like.

# Note: This code is for demonstration. In a real environment, you run pip commands in the terminal.
# Example: pip install camelcase

# 1. Using a Package (assuming 'camelcase' is installed)
try:
    import camelcase

    c = camelcase.CamelCase()
    txt = "hello world"
    print(c.hump(txt))
except ImportError:
    print("The 'camelcase' module is not installed in this environment.")
    print("Run 'pip install camelcase' to install it.")

# 2. List installed packages (simulated)
# In terminal: pip list
print("\nTo list packages, run: pip list")
