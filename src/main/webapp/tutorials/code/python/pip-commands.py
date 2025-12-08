# PIP Command Reference
# Note: These are terminal commands, shown here for reference

print("=== Essential PIP Commands ===")
print("""
# Install a package
pip install package_name

# Install specific version
pip install package_name==1.2.3

# Install minimum version
pip install 'package_name>=1.2.0'

# Upgrade a package
pip install --upgrade package_name

# Uninstall a package
pip uninstall package_name

# List installed packages
pip list

# Show package info
pip show package_name

# Search PyPI (deprecated, use web)
# pip search package_name

# Check for outdated packages
pip list --outdated
""")

print("=== Installing Multiple Packages ===")
print("""
# From requirements.txt
pip install -r requirements.txt

# Install several at once
pip install requests flask numpy

# Install with dependencies
pip install package_name[extra_deps]
""")

print("=== Useful Flags ===")
print("""
--user       Install for current user only
--no-cache   Skip cache when downloading
-q, --quiet  Minimal output
-v, --verbose Detailed output
""")
