# Activating Virtual Environments

print("Activating Virtual Environments")
print("=" * 50)

# Mac/Linux activation
print("\nOn Mac/Linux:")
print("  source myenv/bin/activate")
print("\n  Prompt changes to: (myenv) user@machine:~$")

# Windows activation
print("\nOn Windows (Command Prompt):")
print("  myenv\\Scripts\\activate.bat")
print("\n  Prompt changes to: (myenv) C:\\Users\\user>")

print("\nOn Windows (PowerShell):")
print("  myenv\\Scripts\\Activate.ps1")
print("\n  (May need: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser)")

# What activation does
print("\nActivation does:")
print("  ✓ Modifies PATH to use venv's Python/pip first")
print("  ✓ Changes terminal prompt to show (myenv)")
print("  ✓ Sets VIRTUAL_ENV environment variable")

# Verifying activation
print("\nTo verify activation:")
print("  which python     # Mac/Linux - should show venv path")
print("  where python     # Windows - should show venv path")
print("  python --version # Shows Python version in venv")

# Deactivating
print("\nTo deactivate:")
print("  deactivate")
print("\n  (Works the same on all platforms)")

