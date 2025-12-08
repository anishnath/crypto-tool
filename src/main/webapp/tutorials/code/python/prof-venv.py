# Virtual Environments allow you to create isolated Python environments
# This is crucial for managing dependencies for different projects

# NOTE: These commands are run in the terminal, not in a Python script
# We are showing them here for demonstration purposes

print("To create a virtual environment:")
print("python3 -m venv myenv")

print("\nTo activate the virtual environment:")
print("Windows: myenv\\Scripts\\activate")
print("Mac/Linux: source myenv/bin/activate")

print("\nTo install packages into the environment:")
print("pip install requests")

print("\nTo save your dependencies to a file:")
print("pip freeze > requirements.txt")

print("\nTo install dependencies from a file:")
print("pip install -r requirements.txt")

print("\nTo deactivate the environment:")
print("deactivate")
