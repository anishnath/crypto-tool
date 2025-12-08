# Exercise: Safe Database Query
# Task: Create a function that safely queries a database with proper cleanup.

# Requirements:
# 1. Connect to the database in try block
# 2. Use else for processing the results
# 3. Always disconnect in finally, even if errors occur
# 4. Return the results or an error message

class Database:
    """Simulated database for exercise."""
    def __init__(self, name):
        self.name = name
        self.connected = False

    def connect(self):
        self.connected = True
        print(f"Connected to {self.name}")

    def disconnect(self):
        if self.connected:
            self.connected = False
            print(f"Disconnected from {self.name}")

    def query(self, sql):
        if not self.connected:
            raise RuntimeError("Not connected!")
        if "error" in sql.lower():
            raise ValueError("Query syntax error")
        return [{"id": 1}, {"id": 2}]


def safe_query(db, sql):
    """
    Safely query database with proper cleanup.
    Returns (success, result_or_error).
    """
    # Your code here:
    # 1. Try to connect
    # 2. Use else to query (only if connect succeeded)
    # 3. Use finally to always disconnect
    pass


# Test your function:
db = Database("production")
print("Test 1:", safe_query(db, "SELECT * FROM users"))
print("Test 2:", safe_query(db, "SELECT error FROM bad"))
