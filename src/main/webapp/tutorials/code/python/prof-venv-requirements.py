# Working with requirements.txt

print("Managing Dependencies with requirements.txt")
print("=" * 60)

# Generating requirements.txt
print("\n1. Generate requirements.txt from current environment:")
print("   pip freeze > requirements.txt")
print("\n   This creates a file like:")
print("   requests==2.28.2")
print("   flask==2.3.2")
print("   numpy==1.24.3")

# Installing from requirements.txt
print("\n2. Install packages from requirements.txt:")
print("   pip install -r requirements.txt")
print("\n   This installs exact versions specified in the file")

# Example workflow
print("\n3. Typical Workflow:")
print("   # Setup new environment")
print("   python3 -m venv myproject_env")
print("   source myproject_env/bin/activate")
print("   ")
print("   # Install from requirements")
print("   pip install -r requirements.txt")
print("   ")
print("   # After adding new package")
print("   pip install new-package==1.2.3")
print("   pip freeze > requirements.txt  # Update requirements")

# Benefits
print("\n4. Benefits of requirements.txt:")
print("   ✓ Reproducibility: Exact same environment everywhere")
print("   ✓ Version control: Track dependency changes in git")
print("   ✓ Documentation: See what packages project uses")
print("   ✓ Deployment: Easy to recreate production environment")

# Best practices
print("\n5. Best Practices:")
print("   ✓ Commit requirements.txt to version control")
print("   ✓ Update it whenever you install/upgrade packages")
print("   ✓ Use specific versions (not '>=', '~=') for production")
print("   ✓ Never commit the venv/ directory itself")





