# pathlib Module - Modern Path Handling (Python 3.4+)

from pathlib import Path

# 1. Creating Path objects
print("=== Creating Paths ===")
p = Path("folder/subfolder/file.txt")
print(f"Path: {p}")
print(f"Type: {type(p)}")

# Path from parts
p2 = Path("folder") / "subfolder" / "file.txt"
print(f"Using /: {p2}")

# Current directory
cwd = Path.cwd()
print(f"Current dir: {cwd}")

# Home directory
home = Path.home()
print(f"Home dir: {home}")
print()

# 2. Path components
print("=== Path Components ===")
p = Path("/home/user/documents/report.pdf")
print(f"Full path: {p}")
print(f"Parent: {p.parent}")
print(f"Name: {p.name}")
print(f"Stem: {p.stem}")
print(f"Suffix: {p.suffix}")
print(f"Parts: {p.parts}")
print()

# 3. Multiple parents
print("=== Parent Chain ===")
p = Path("/home/user/docs/project/file.py")
print(f"Path: {p}")
for i, parent in enumerate(p.parents):
    print(f"  Parent {i}: {parent}")
print()

# 4. Path properties
print("=== Path Properties ===")
p = Path(".")
print(f"Absolute: {p.absolute()}")
print(f"Resolved: {p.resolve()}")
print(f"Exists: {p.exists()}")
print(f"Is file: {p.is_file()}")
print(f"Is dir: {p.is_dir()}")
print()

# 5. Changing path parts
print("=== Modifying Paths ===")
p = Path("/home/user/document.txt")
print(f"Original: {p}")
print(f"New name: {p.with_name('report.txt')}")
print(f"New suffix: {p.with_suffix('.pdf')}")
print(f"New stem: {p.with_stem('data')}")
print()

# 6. Comparing pathlib to os.path
print("=== pathlib vs os.path ===")
print("""
pathlib                    os.path
----------------------------------------------
Path("a") / "b"            os.path.join("a", "b")
p.parent                   os.path.dirname(p)
p.name                     os.path.basename(p)
p.suffix                   os.path.splitext(p)[1]
p.stem                     os.path.splitext(basename)[0]
p.exists()                 os.path.exists(p)
p.is_file()                os.path.isfile(p)
p.is_dir()                 os.path.isdir(p)
p.resolve()                os.path.abspath(p)
Path.home()                os.path.expanduser("~")
p.stat().st_size           os.path.getsize(p)
""")
