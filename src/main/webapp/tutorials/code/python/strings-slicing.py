# String Slicing in Python
# Syntax: string[start:end:step]
# - start: beginning index (inclusive)
# - end: ending index (exclusive)
# - step: increment (optional, default=1)

text = "Python Programming"
print(f"Original: '{text}'")
print(f"Length: {len(text)}")

print("\n" + "=" * 40)
print("Basic Slicing [start:end]:")
print(f"text[0:6]  = '{text[0:6]}'")   # 'Python'
print(f"text[7:18] = '{text[7:18]}'")  # 'Programming'
print(f"text[7:11] = '{text[7:11]}'")  # 'Prog'

print("\n" + "=" * 40)
print("Omitting start or end:")
print(f"text[:6]   = '{text[:6]}'")    # First 6 chars
print(f"text[7:]   = '{text[7:]}'")    # From index 7 to end
print(f"text[:]    = '{text[:]}'")     # Copy entire string

print("\n" + "=" * 40)
print("Negative indices in slicing:")
print(f"text[-11:]  = '{text[-11:]}'")  # Last 11 chars
print(f"text[:-12] = '{text[:-12]}'")   # All except last 12
print(f"text[-11:-4] = '{text[-11:-4]}'")

print("\n" + "=" * 40)
print("Using step [start:end:step]:")
print(f"text[::2]   = '{text[::2]}'")     # Every 2nd char
print(f"text[::3]   = '{text[::3]}'")     # Every 3rd char
print(f"text[0:6:2] = '{text[0:6:2]}'")   # 'Pto'

print("\n" + "=" * 40)
print("Reverse a string (step = -1):")
print(f"text[::-1] = '{text[::-1]}'")

# Practical examples
print("\n" + "=" * 40)
print("Practical Examples:")
url = "https://example.com/page"
print(f"URL: {url}")
print(f"Protocol: {url[:5]}")        # 'https'
print(f"Domain: {url[8:19]}")        # 'example.com'

filename = "document.pdf"
print(f"\nFilename: {filename}")
print(f"Name: {filename[:-4]}")      # 'document'
print(f"Extension: {filename[-3:]}") # 'pdf'
