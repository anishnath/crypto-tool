# Working with requirements.txt

print("=== requirements.txt Format ===")
print("""
# Example requirements.txt file:
# ---------------------------------
requests==2.28.0
flask>=2.0.0
numpy
pandas>=1.3.0,<2.0.0
python-dateutil~=2.8.0
---------------------------------

Version specifiers:
  ==1.2.3    Exact version
  >=1.2.0    Minimum version
  <=1.2.0    Maximum version
  ~=1.2.0    Compatible release (~=1.2.0 means >=1.2.0, <1.3.0)
  !=1.2.3    Exclude version
  >=1.2,<2.0 Range
""")

print("=== Creating requirements.txt ===")
print("""
# Freeze current environment
pip freeze > requirements.txt

# This creates a file with all installed packages
# and their exact versions
""")

print("=== Installing from requirements.txt ===")
print("""
# Install all packages listed
pip install -r requirements.txt

# Common workflow:
# 1. Clone project
# 2. Create virtual environment
# 3. pip install -r requirements.txt
# 4. Start coding!
""")

# Simulating checking installed packages
print("\n=== Check If Package Is Installed ===")
packages = ["requests", "flask", "numpy", "nonexistent_package"]

for pkg in packages:
    try:
        __import__(pkg)
        print(f"{pkg}: Installed")
    except ImportError:
        print(f"{pkg}: Not installed")
