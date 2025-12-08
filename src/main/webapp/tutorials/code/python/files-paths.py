# Python Working with Paths
import os
from pathlib import Path

# 1. Using os.path
print("--- os.path ---")
current_dir = os.getcwd()
print(f"Current Directory: {current_dir}")

file_path = os.path.join(current_dir, "demofile.txt")
print(f"Full Path: {file_path}")

print(f"Exists? {os.path.exists(file_path)}")
print(f"Is File? {os.path.isfile(file_path)}")
print(f"Dir Name: {os.path.dirname(file_path)}")
print(f"Base Name: {os.path.basename(file_path)}")

# 2. Using pathlib (Modern Approach)
print("\n--- pathlib ---")
path = Path("demofile.txt")

print(f"Exists? {path.exists()}")
print(f"Is File? {path.is_file()}")
print(f"Absolute: {path.resolve()}")
print(f"Parent: {path.parent}")
print(f"Name: {path.name}")
print(f"Stem: {path.stem}")
print(f"Suffix: {path.suffix}")
