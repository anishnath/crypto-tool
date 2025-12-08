# File and Directory Operations

from pathlib import Path
import shutil

# 1. Creating directories
print("=== Creating Directories ===")
# Single directory
Path("test_dir").mkdir(exist_ok=True)
print("Created: test_dir")

# Nested directories (like mkdir -p)
Path("test_dir/sub1/sub2").mkdir(parents=True, exist_ok=True)
print("Created: test_dir/sub1/sub2")
print()

# 2. Creating files
print("=== Creating Files ===")
# touch equivalent
Path("test_dir/file1.txt").touch()
print("Created: test_dir/file1.txt")

# Write and read with pathlib
p = Path("test_dir/file2.txt")
p.write_text("Hello from pathlib!")
print(f"Wrote: {p}")
content = p.read_text()
print(f"Read: {content}")
print()

# 3. Renaming and moving
print("=== Renaming Files ===")
src = Path("test_dir/file1.txt")
dst = Path("test_dir/renamed.txt")
src.rename(dst)
print(f"Renamed: {src} -> {dst}")
print()

# 4. Copying files (use shutil)
print("=== Copying Files ===")
shutil.copy("test_dir/file2.txt", "test_dir/file2_copy.txt")
print("Copied: file2.txt -> file2_copy.txt")

# Copy directory
shutil.copytree("test_dir/sub1", "test_dir/sub1_copy")
print("Copied directory: sub1 -> sub1_copy")
print()

# 5. Checking existence
print("=== Existence Checks ===")
p = Path("test_dir")
print(f"Exists: {p.exists()}")
print(f"Is file: {p.is_file()}")
print(f"Is directory: {p.is_dir()}")
print(f"Is symlink: {p.is_symlink()}")
print()

# 6. File stats
print("=== File Statistics ===")
p = Path("test_dir/file2.txt")
stat = p.stat()
print(f"Size: {stat.st_size} bytes")
print(f"Mode: {oct(stat.st_mode)}")

from datetime import datetime
mtime = datetime.fromtimestamp(stat.st_mtime)
print(f"Modified: {mtime}")
print()

# 7. Deleting files and directories
print("=== Deleting ===")
# Delete file
Path("test_dir/renamed.txt").unlink()
print("Deleted: renamed.txt")

# Delete empty directory
# Path("empty_dir").rmdir()  # Only works if empty

# Delete directory with contents
shutil.rmtree("test_dir")
print("Deleted: test_dir and all contents")
print()

# 8. Common operations summary
print("=== Operations Summary ===")
print("""
Path("dir").mkdir()          - Create directory
Path("dir").mkdir(parents=True)  - Create nested dirs
Path("file").touch()         - Create empty file
Path("file").write_text(s)   - Write string to file
Path("file").read_text()     - Read file as string
Path("file").write_bytes(b)  - Write bytes
Path("file").read_bytes()    - Read as bytes
Path("old").rename("new")    - Rename/move
Path("file").unlink()        - Delete file
Path("dir").rmdir()          - Delete empty directory
shutil.copy(src, dst)        - Copy file
shutil.copytree(src, dst)    - Copy directory
shutil.rmtree(path)          - Delete directory tree
""")
