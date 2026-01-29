import os

# List files in current directory
files = os.listdir(".")
print("Files in current directory:")
for file in files[:5]:  # Show first 5
    print(f"  - {file}")

# Count files
print(f"\nTotal files: {len(files)}")
