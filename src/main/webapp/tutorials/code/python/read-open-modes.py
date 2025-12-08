# File Open Modes

# Create a sample file first
with open("sample.txt", "w") as f:
    f.write("Hello, World!\n")
    f.write("This is a sample file.\n")
    f.write("Python file handling is easy!")

print("=== File Open Modes ===")
print("""
Mode  Description
----  -----------
'r'   Read (default) - file must exist
'w'   Write - creates new or truncates existing
'a'   Append - creates new or appends to existing
'x'   Create - fails if file exists
'b'   Binary mode (add to other modes: 'rb', 'wb')
't'   Text mode (default, add to other modes)
'+'   Read and write (add to other modes: 'r+', 'w+')
""")

# 1. Read mode ('r') - default
print("=== Read Mode ('r') ===")
f = open("sample.txt", "r")
content = f.read()
print(f"Content:\n{content}")
f.close()
print()

# 2. Read mode explicitly with 't' (text)
print("=== Text Mode ('rt') ===")
f = open("sample.txt", "rt")  # 'rt' = read text (same as 'r')
print(f"First line: {f.readline().strip()}")
f.close()
print()

# 3. Binary mode ('rb')
print("=== Binary Mode ('rb') ===")
f = open("sample.txt", "rb")
binary_content = f.read()
print(f"Type: {type(binary_content)}")
print(f"First 20 bytes: {binary_content[:20]}")
f.close()
print()

# 4. Read and Write mode ('r+')
print("=== Read/Write Mode ('r+') ===")
f = open("sample.txt", "r+")
print(f"Can read: {f.read(13)}")
# Position is now at character 13
f.close()

# Cleanup
import os
os.remove("sample.txt")
print("(Cleaned up sample file)")
