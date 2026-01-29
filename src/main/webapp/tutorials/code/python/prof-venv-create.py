# Creating Virtual Environments

print("Creating a Virtual Environment")
print("=" * 50)

# Command to create virtual environment
print("\nCommand:")
print("  python3 -m venv myenv")
print("\n  OR")
print("  python -m venv myenv  (if python3 is aliased to python)")

# What gets created
print("\nThis creates a directory structure:")
print("  myenv/")
print("    ├── bin/           (or Scripts/ on Windows)")
print("    │   ├── activate")
print("    │   ├── python     (Python interpreter)")
print("    │   └── pip        (Package installer)")
print("    ├── include/       (Header files)")
print("    ├── lib/           (Installed packages)")
print("    └── pyvenv.cfg     (Configuration)")

# Python version
print("\nThe virtual environment uses:")
print("  - The Python version used to create it")
print("  - Its own copy of pip and standard library")
print("  - Isolated package installation directory")

# Creating with specific Python version
print("\nTo create with specific Python version:")
print("  python3.9 -m venv myenv39")
print("  python3.11 -m venv myenv311")





