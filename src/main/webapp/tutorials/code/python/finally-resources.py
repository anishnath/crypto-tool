# Resource Management with Finally

print("=== Resource Management ===\n")

# 1. Classic pattern: file handling
print("1. File Handling with Finally:")

def read_file_safely(filename):
    f = None
    try:
        f = open(filename, 'r')
        return f.read()
    except FileNotFoundError:
        return None
    finally:
        if f is not None:
            f.close()
            print(f"   Closed file: {filename}")

content = read_file_safely("nonexistent.txt")
print(f"   Content: {content}")
print()

# 2. Better: context manager (with statement)
print("2. Better Approach - Context Manager:")
print("""
# Instead of:
f = None
try:
    f = open(filename)
    data = f.read()
finally:
    if f:
        f.close()

# Use this:
with open(filename) as f:
    data = f.read()
# Automatically closed!
""")

# 3. Database connection pattern
print("3. Database Connection Pattern:")

class FakeDatabase:
    def __init__(self, name):
        self.name = name
        self.connected = False

    def connect(self):
        self.connected = True
        print(f"   Connected to {self.name}")

    def query(self, sql):
        if not self.connected:
            raise RuntimeError("Not connected!")
        if "error" in sql:
            raise ValueError("Query failed")
        return [{"id": 1, "name": "Alice"}]

    def disconnect(self):
        self.connected = False
        print(f"   Disconnected from {self.name}")


def fetch_users(db):
    try:
        db.connect()
        users = db.query("SELECT * FROM users")
        return users
    except ValueError as e:
        print(f"   Query error: {e}")
        return []
    finally:
        db.disconnect()  # Always disconnect!


db = FakeDatabase("production")
users = fetch_users(db)
print(f"   Users: {users}")
print()

# 4. Lock pattern (threading)
print("4. Lock Pattern (Threading):")
print("""
import threading
lock = threading.Lock()

# With finally:
lock.acquire()
try:
    # Critical section
    do_work()
finally:
    lock.release()  # Always release!

# Better - use context manager:
with lock:
    do_work()
# Automatically released!
""")

# 5. Multiple resources
print("5. Multiple Resources:")

def process_files(input_name, output_name):
    infile = None
    outfile = None
    try:
        infile = open(input_name, 'r')
        outfile = open(output_name, 'w')
        # Process...
        outfile.write(infile.read().upper())
        return True
    except FileNotFoundError as e:
        print(f"   Error: {e}")
        return False
    finally:
        # Close both files
        if infile:
            infile.close()
            print("   Closed input file")
        if outfile:
            outfile.close()
            print("   Closed output file")


# Better with context managers:
print("\n   Better approach:")
print("""
with open(input_name) as infile, open(output_name, 'w') as outfile:
    outfile.write(infile.read().upper())
# Both automatically closed!
""")

# 6. Custom cleanup
print("6. Custom Cleanup Pattern:")

class Timer:
    def __init__(self, name):
        self.name = name
        self.start_time = None

    def start(self):
        import time
        self.start_time = time.time()
        print(f"   Timer '{self.name}' started")

    def stop(self):
        import time
        if self.start_time:
            elapsed = time.time() - self.start_time
            print(f"   Timer '{self.name}' stopped: {elapsed:.4f}s")


timer = Timer("processing")
try:
    timer.start()
    # Simulate work
    total = sum(range(100000))
except Exception as e:
    print(f"   Error: {e}")
finally:
    timer.stop()  # Always stop timer

print()
print("=== Key Takeaway ===")
print("Use 'with' statements when possible - they're cleaner than try/finally!")
