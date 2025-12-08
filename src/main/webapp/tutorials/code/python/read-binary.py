# Reading Binary Files

# Create a sample binary file
with open("sample.bin", "wb") as f:
    # Write some bytes
    f.write(b"Hello Binary World!")
    f.write(bytes([0, 1, 2, 3, 4, 255]))

# 1. Read entire binary file
print("=== Read Binary File ===")
with open("sample.bin", "rb") as f:
    data = f.read()
    print(f"Type: {type(data)}")
    print(f"Length: {len(data)} bytes")
    print(f"Content: {data}")
print()

# 2. Read binary in chunks
print("=== Read in Chunks ===")
with open("sample.bin", "rb") as f:
    chunk_size = 8
    chunk_num = 1
    while True:
        chunk = f.read(chunk_size)
        if not chunk:
            break
        print(f"Chunk {chunk_num}: {chunk}")
        chunk_num += 1
print()

# 3. Read specific bytes
print("=== Read Specific Positions ===")
with open("sample.bin", "rb") as f:
    # Read first 5 bytes
    first_five = f.read(5)
    print(f"First 5 bytes: {first_five}")

    # Skip to position 6
    f.seek(6)
    rest = f.read(6)
    print(f"Bytes 6-11: {rest}")

    # Get current position
    print(f"Current position: {f.tell()}")
print()

# 4. File position methods
print("=== File Position ===")
with open("sample.bin", "rb") as f:
    print(f"Start position: {f.tell()}")
    f.read(10)
    print(f"After reading 10: {f.tell()}")
    f.seek(0)  # Go back to start
    print(f"After seek(0): {f.tell()}")
    f.seek(0, 2)  # Go to end (2 = from end)
    print(f"File size: {f.tell()} bytes")

# Cleanup
import os
os.remove("sample.bin")
print("\n(Cleaned up binary file)")
