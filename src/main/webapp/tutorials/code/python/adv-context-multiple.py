# Multiple Context Managers

# Using multiple context managers in one with statement

# Method 1: Separate lines
print("Multiple context managers (separate lines):")
with open('file1.txt', 'w') as f1:
    with open('file2.txt', 'w') as f2:
        f1.write("Content 1")
        f2.write("Content 2")

# Method 2: Using commas (Python 3.1+)
print("\nMultiple context managers (comma syntax):")
with open('file1.txt', 'r') as f1, open('file2.txt', 'r') as f2:
    print("File 1:", f1.read())
    print("File 2:", f2.read())


# Practical example: Copying data between files
print("\nCopying data between files:")
with open('source.txt', 'w') as source:
    source.write("Source content")

with open('source.txt', 'r') as source, open('dest.txt', 'w') as dest:
    content = source.read()
    dest.write(content)

with open('dest.txt', 'r') as dest:
    print("Copied content:", dest.read())


# Custom context managers can be combined too
class Timer:
    def __enter__(self):
        import time
        self.start = time.time()
        return self
    
    def __exit__(self, *args):
        import time
        elapsed = time.time() - self.start
        print(f"Time elapsed: {elapsed:.4f}s")

class Logger:
    def __init__(self, name):
        self.name = name
    
    def __enter__(self):
        print(f"Starting {self.name}")
        return self
    
    def __exit__(self, *args):
        print(f"Finished {self.name}")

print("\nCombining multiple custom context managers:")
with Timer(), Logger("operation"):
    import time
    time.sleep(0.1)





