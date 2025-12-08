# CSV Dialects and Options

import csv
import os

# 1. Different delimiters
print("=== Delimiter Options ===")

# Semicolon separated (common in Europe)
data = [["Name", "Price", "Quantity"], ["Apple", "1.50", "10"]]
with open("semicolon.csv", "w", newline="") as f:
    writer = csv.writer(f, delimiter=";")
    writer.writerows(data)

with open("semicolon.csv", "r") as f:
    print(f"Semicolon: {f.read().strip()}")

# Tab separated (TSV)
with open("tabs.tsv", "w", newline="") as f:
    writer = csv.writer(f, delimiter="\t")
    writer.writerows(data)

with open("tabs.tsv", "r") as f:
    print(f"Tab: {f.read().strip()}")
print()

# 2. Quoting options
print("=== Quoting Options ===")
tricky_data = [
    ["name", "description", "price"],
    ["Widget", "A great, useful item", "9.99"],
    ["Gadget", 'Has "special" features', "19.99"],
    ["Thing", "Contains, commas, inside", "5.00"]
]

# QUOTE_MINIMAL (default) - only quote when necessary
with open("quote_minimal.csv", "w", newline="") as f:
    writer = csv.writer(f, quoting=csv.QUOTE_MINIMAL)
    writer.writerows(tricky_data)

print("QUOTE_MINIMAL:")
with open("quote_minimal.csv", "r") as f:
    print(f.read())

# QUOTE_ALL - quote everything
with open("quote_all.csv", "w", newline="") as f:
    writer = csv.writer(f, quoting=csv.QUOTE_ALL)
    writer.writerows(tricky_data)

print("QUOTE_ALL:")
with open("quote_all.csv", "r") as f:
    print(f.read())

# QUOTE_NONNUMERIC - quote strings only
with open("quote_nonnumeric.csv", "w", newline="") as f:
    writer = csv.writer(f, quoting=csv.QUOTE_NONNUMERIC)
    writer.writerows(tricky_data)

print("QUOTE_NONNUMERIC:")
with open("quote_nonnumeric.csv", "r") as f:
    print(f.read())

# 3. Excel dialect
print("=== Excel Dialect ===")
with open("excel.csv", "w", newline="") as f:
    writer = csv.writer(f, dialect="excel")
    writer.writerows(tricky_data)

with open("excel.csv", "r") as f:
    reader = csv.reader(f, dialect="excel")
    for row in reader:
        print(row)
print()

# 4. Custom dialect
print("=== Custom Dialect ===")
csv.register_dialect(
    "custom",
    delimiter="|",
    quoting=csv.QUOTE_ALL,
    quotechar="'",
    lineterminator="\n"
)

with open("custom.csv", "w", newline="") as f:
    writer = csv.writer(f, dialect="custom")
    writer.writerows([["A", "B"], ["1", "2"]])

with open("custom.csv", "r") as f:
    print(f"Custom format: {f.read().strip()}")
print()

# 5. List available dialects
print("=== Available Dialects ===")
print(f"Dialects: {csv.list_dialects()}")

# Cleanup
for fname in ["semicolon.csv", "tabs.tsv", "quote_minimal.csv",
              "quote_all.csv", "quote_nonnumeric.csv", "excel.csv", "custom.csv"]:
    if os.path.exists(fname):
        os.remove(fname)
print("\n(Cleaned up files)")
