# Practical CSV Examples

import csv
import os
from collections import defaultdict

# Create sample sales data
sales_data = """date,product,quantity,price,region
2024-01-15,Widget,10,9.99,North
2024-01-15,Gadget,5,19.99,South
2024-01-16,Widget,8,9.99,North
2024-01-16,Gadget,12,19.99,East
2024-01-17,Widget,15,9.99,South
2024-01-17,Thing,20,5.00,North
2024-01-18,Gadget,7,19.99,West
2024-01-18,Thing,25,5.00,East"""

with open("sales.csv", "w") as f:
    f.write(sales_data)

# 1. Calculate totals
print("=== Calculate Revenue by Product ===")
revenue = defaultdict(float)

with open("sales.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        product = row["product"]
        total = int(row["quantity"]) * float(row["price"])
        revenue[product] += total

for product, total in sorted(revenue.items(), key=lambda x: -x[1]):
    print(f"  {product}: ${total:.2f}")
print()

# 2. Filter and transform
print("=== Filter: High-Volume Sales ===")
high_volume = []

with open("sales.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        if int(row["quantity"]) >= 10:
            high_volume.append(row)

print(f"Found {len(high_volume)} high-volume sales:")
for sale in high_volume:
    print(f"  {sale['date']}: {sale['quantity']} x {sale['product']}")
print()

# 3. Group by region
print("=== Sales by Region ===")
by_region = defaultdict(list)

with open("sales.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        by_region[row["region"]].append(row)

for region, sales in sorted(by_region.items()):
    total_qty = sum(int(s["quantity"]) for s in sales)
    print(f"  {region}: {total_qty} units ({len(sales)} orders)")
print()

# 4. Add calculated column and write new file
print("=== Add Calculated Column ===")
with open("sales.csv", "r") as infile, \
     open("sales_with_total.csv", "w", newline="") as outfile:

    reader = csv.DictReader(infile)
    fieldnames = reader.fieldnames + ["total"]
    writer = csv.DictWriter(outfile, fieldnames=fieldnames)

    writer.writeheader()
    for row in reader:
        row["total"] = f"{int(row['quantity']) * float(row['price']):.2f}"
        writer.writerow(row)

# Show result
with open("sales_with_total.csv", "r") as f:
    print(f.read())
print()

# 5. Convert CSV to list of objects
print("=== CSV to Objects ===")
class Sale:
    def __init__(self, date, product, quantity, price, region):
        self.date = date
        self.product = product
        self.quantity = int(quantity)
        self.price = float(price)
        self.region = region

    def revenue(self):
        return self.quantity * self.price

    def __repr__(self):
        return f"Sale({self.product}, {self.quantity}x${self.price})"

sales = []
with open("sales.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        sales.append(Sale(**row))

print(f"Loaded {len(sales)} sales")
print(f"First sale: {sales[0]}")
print(f"Total revenue: ${sum(s.revenue() for s in sales):.2f}")

# Cleanup
os.remove("sales.csv")
os.remove("sales_with_total.csv")
print("\n(Cleaned up files)")
