import sqlite3

# Create a connection to a database (in memory for this example)
conn = sqlite3.connect(':memory:')
# For a file: conn = sqlite3.connect('example.db')

# Create a cursor object
c = conn.cursor()

# Create a table
c.execute('''CREATE TABLE users
             (id INTEGER PRIMARY KEY, name TEXT, email TEXT)''')

# Insert data
c.execute("INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com')")
c.execute("INSERT INTO users (name, email) VALUES ('Bob', 'bob@example.com')")

# Save (commit) the changes
conn.commit()

# Query data
print("--- All Users ---")
c.execute("SELECT * FROM users")
rows = c.fetchall()
for row in rows:
    print(row)

print("\n--- Specific User ---")
c.execute("SELECT * FROM users WHERE name=?", ('Alice',))
print(c.fetchone())

# Close the connection
conn.close()
