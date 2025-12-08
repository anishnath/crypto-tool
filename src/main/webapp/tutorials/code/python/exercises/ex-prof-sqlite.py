import sqlite3

conn = sqlite3.connect(':memory:')
c = conn.cursor()

# 1. Create a table named 'products' with columns: id (integer), name (text), price (real)
c.execute("CREATE TABLE products ...")

# 2. Insert a product: 'Laptop', 999.99
c.execute("INSERT INTO products ...")

conn.commit()

# 3. Select and print all products
c.execute("SELECT ...")
print(c.fetchall())

conn.close()
