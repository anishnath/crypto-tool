# os.path Module - Traditional Path Handling

import os
import os.path

# 1. Joining paths (cross-platform!)
print("=== os.path.join() ===")
path = os.path.join("folder", "subfolder", "file.txt")
print(f"Joined path: {path}")

# Works on any OS
base = os.path.join(os.path.expanduser("~"), "Documents")
print(f"Home docs: {base}")
print()

# 2. Splitting paths
print("=== Splitting Paths ===")
full_path = "/home/user/documents/report.pdf"

dirname = os.path.dirname(full_path)
basename = os.path.basename(full_path)
print(f"Directory: {dirname}")
print(f"Filename: {basename}")

# Split into (directory, filename)
head, tail = os.path.split(full_path)
print(f"split(): {head} + {tail}")

# Split extension
name, ext = os.path.splitext(full_path)
print(f"splitext(): {name} + {ext}")
print()

# 3. Path information
print("=== Path Information ===")
test_path = os.path.abspath(".")
print(f"Absolute path: {test_path}")
print(f"Current working directory: {os.getcwd()}")
print(f"Path exists: {os.path.exists(test_path)}")
print(f"Is file: {os.path.isfile(test_path)}")
print(f"Is directory: {os.path.isdir(test_path)}")
print()

# 4. Normalizing paths
print("=== Normalizing Paths ===")
messy = "folder//subfolder/../subfolder/./file.txt"
clean = os.path.normpath(messy)
print(f"Before: {messy}")
print(f"After:  {clean}")
print()

# 5. Getting file info
print("=== File Information ===")
if os.path.exists(__file__ if '__file__' in dir() else "."):
    sample = __file__ if '__file__' in dir() else "."
    print(f"Size: {os.path.getsize(sample)} bytes")
    import time
    mtime = os.path.getmtime(sample)
    print(f"Modified: {time.ctime(mtime)}")
print()

# 6. Common os.path functions summary
print("=== Common os.path Functions ===")
print("""
os.path.join(a, b)      - Join paths
os.path.split(path)     - Split into (dir, file)
os.path.splitext(path)  - Split into (name, .ext)
os.path.basename(path)  - Get filename
os.path.dirname(path)   - Get directory
os.path.exists(path)    - Check if exists
os.path.isfile(path)    - Check if file
os.path.isdir(path)     - Check if directory
os.path.abspath(path)   - Get absolute path
os.path.expanduser("~") - Expand ~ to home
os.path.getsize(path)   - Get file size
os.path.getmtime(path)  - Get modification time
""")
