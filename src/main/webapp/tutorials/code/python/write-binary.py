# Writing Binary Files

import os

# 1. Write bytes to a file
print("=== Write Bytes ===")
with open("data.bin", "wb") as f:
    # Write a bytes literal
    f.write(b"Hello Binary!")
    # Write raw bytes
    f.write(bytes([0, 1, 2, 255, 254, 253]))

# Read back
with open("data.bin", "rb") as f:
    data = f.read()
    print(f"Type: {type(data)}")
    print(f"Content: {data}")
    print(f"Length: {len(data)} bytes")
print()

# 2. Write bytearray (mutable bytes)
print("=== Write Bytearray ===")
data = bytearray([72, 101, 108, 108, 111])  # "Hello" in ASCII
data.append(33)  # Add "!"
with open("array.bin", "wb") as f:
    f.write(data)

with open("array.bin", "rb") as f:
    print(f"Read back: {f.read()}")
print()

# 3. Write at specific positions
print("=== Write at Positions ===")
with open("positions.bin", "wb") as f:
    f.write(b"0123456789")

# Modify using r+b (read/write binary)
with open("positions.bin", "r+b") as f:
    f.seek(5)  # Go to position 5
    f.write(b"XXX")  # Overwrite 3 bytes

with open("positions.bin", "rb") as f:
    print(f"Modified: {f.read()}")
print()

# 4. Encoding strings to bytes
print("=== Encode Strings to Bytes ===")
text = "Python Unicode: café ñ"
with open("encoded.bin", "wb") as f:
    encoded = text.encode("utf-8")
    f.write(encoded)
    print(f"Encoded bytes: {encoded}")

with open("encoded.bin", "rb") as f:
    raw = f.read()
    decoded = raw.decode("utf-8")
    print(f"Decoded: {decoded}")
print()

# 5. Write structured binary data
print("=== Structured Binary Data ===")
import struct

# Pack integers into bytes
numbers = [100, 200, 300]
with open("numbers.bin", "wb") as f:
    for num in numbers:
        # 'i' = 4-byte signed integer
        packed = struct.pack('i', num)
        f.write(packed)

# Read back
with open("numbers.bin", "rb") as f:
    while True:
        data = f.read(4)
        if not data:
            break
        num = struct.unpack('i', data)[0]
        print(f"Read number: {num}")

# Cleanup
for fname in ["data.bin", "array.bin", "positions.bin", "encoded.bin", "numbers.bin"]:
    os.remove(fname)
print("\n(Cleaned up binary files)")
