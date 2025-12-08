# Virtual Environments
# Isolate project dependencies

print("=== Why Virtual Environments? ===")
print("""
Problem: Different projects need different versions
- Project A needs requests==2.25.0
- Project B needs requests==2.28.0
- Installing one breaks the other!

Solution: Virtual environments
- Each project gets its own Python environment
- Packages installed in isolation
- No conflicts between projects
""")

print("=== Creating Virtual Environments ===")
print("""
# Using venv (built-in, Python 3.3+)
python -m venv myenv

# This creates a folder 'myenv' with:
# - Python interpreter
# - pip
# - Empty site-packages
""")

print("=== Activating Virtual Environment ===")
print("""
# Windows
myenv\\Scripts\\activate

# macOS/Linux
source myenv/bin/activate

# Your prompt changes to show active env:
# (myenv) $

# Now pip install only affects this env!
""")

print("=== Deactivating ===")
print("""
# Simply run:
deactivate

# Prompt returns to normal
""")

print("=== Best Practices ===")
print("""
1. One virtual env per project
2. Add 'venv/' to .gitignore
3. Use requirements.txt for dependencies
4. Document Python version needed

# Typical workflow:
python -m venv venv
source venv/bin/activate  # or venv\\Scripts\\activate
pip install -r requirements.txt
# ... work on project ...
deactivate
""")
