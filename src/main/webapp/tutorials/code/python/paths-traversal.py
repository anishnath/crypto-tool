# Directory Traversal and Pattern Matching

from pathlib import Path
import os

# Setup test structure
print("=== Creating Test Structure ===")
base = Path("test_project")
(base / "src").mkdir(parents=True, exist_ok=True)
(base / "tests").mkdir(exist_ok=True)
(base / "docs").mkdir(exist_ok=True)

# Create sample files
(base / "README.md").touch()
(base / "setup.py").touch()
(base / "src" / "main.py").touch()
(base / "src" / "utils.py").touch()
(base / "src" / "config.json").touch()
(base / "tests" / "test_main.py").touch()
(base / "tests" / "test_utils.py").touch()
(base / "docs" / "guide.md").touch()
print("Created test project structure")
print()

# 1. iterdir() - list directory contents
print("=== iterdir() - List Contents ===")
for item in base.iterdir():
    item_type = "DIR" if item.is_dir() else "FILE"
    print(f"  [{item_type}] {item.name}")
print()

# 2. glob() - pattern matching
print("=== glob() - Find Files ===")
print("All .py files:")
for py_file in base.glob("*.py"):
    print(f"  {py_file}")

print("\nAll .py files (recursive):")
for py_file in base.glob("**/*.py"):
    print(f"  {py_file}")

print("\nAll .md files (recursive):")
for md_file in base.glob("**/*.md"):
    print(f"  {md_file}")
print()

# 3. rglob() - recursive glob shortcut
print("=== rglob() - Recursive Search ===")
print("All test files:")
for test_file in base.rglob("test_*.py"):
    print(f"  {test_file}")
print()

# 4. os.walk() - traverse directory tree
print("=== os.walk() - Walk Directory Tree ===")
for dirpath, dirnames, filenames in os.walk(base):
    level = dirpath.replace(str(base), "").count(os.sep)
    indent = "  " * level
    print(f"{indent}{Path(dirpath).name}/")
    for filename in filenames:
        print(f"{indent}  {filename}")
print()

# 5. Filter by criteria
print("=== Custom Filtering ===")
print("Files larger than 0 bytes or recently modified:")
for path in base.rglob("*"):
    if path.is_file():
        stat = path.stat()
        print(f"  {path.name}: {stat.st_size} bytes")
print()

# 6. Practical example: find all Python files
print("=== Find Python Files ===")
def find_python_files(directory):
    """Find all Python files in directory."""
    root = Path(directory)
    return list(root.rglob("*.py"))

python_files = find_python_files(base)
print(f"Found {len(python_files)} Python files:")
for f in python_files:
    print(f"  {f.relative_to(base)}")
print()

# 7. Cleanup
import shutil
shutil.rmtree(base)
print("(Cleaned up test structure)")
print()

# 8. Traversal methods summary
print("=== Traversal Summary ===")
print("""
path.iterdir()          - List immediate contents
path.glob("*.txt")      - Match pattern in directory
path.glob("**/*.txt")   - Match pattern recursively
path.rglob("*.txt")     - Shortcut for **/*.txt
os.walk(path)           - Walk entire tree

Common glob patterns:
  *           - Any characters (not /)
  **          - Any path (recursive)
  ?           - Single character
  [abc]       - Character set
  *.py        - Python files
  **/test_*   - All test files anywhere
""")
