# Exercise: E-Commerce Product System
# Create a product management system using dataclasses

from dataclasses import dataclass, field
from typing import List

# 1. Create a Product dataclass with:
#    - sku: str (stock keeping unit)
#    - name: str
#    - price: float
#    - quantity: int (default 0)
#    - category: str (default "General")
#    - Method: total_value() returns price * quantity
# Your code here:


# 2. Create an Order dataclass with:
#    - order_id: str
#    - customer: str
#    - items: List[Product] (use default_factory)
#    - discount: float (default 0.0, don't show in repr)
#    - Method: add_item(product) - adds product to items
#    - Method: subtotal() - sum of all item prices
#    - Method: total() - subtotal minus discount
# Your code here:


# 3. Create a frozen (immutable) Address dataclass with:
#    - street: str
#    - city: str
#    - zip_code: str
#    - country: str (default "USA")
# Your code here:



# Test your implementation:

# p1 = Product("SKU001", "Laptop", 999.99, 2)
# p2 = Product("SKU002", "Mouse", 29.99, 5)
# p3 = Product("SKU003", "Keyboard", 79.99, 3, "Electronics")

# print("Products:")
# print(f"  {p1}")
# print(f"  Total value: ${p1.total_value():.2f}")

# order = Order("ORD-001", "Alice")
# order.add_item(p1)
# order.add_item(p2)
# order.add_item(p3)

# print(f"\nOrder: {order.order_id}")
# print(f"  Items: {len(order.items)}")
# print(f"  Subtotal: ${order.subtotal():.2f}")
# order.discount = 100.00
# print(f"  After $100 discount: ${order.total():.2f}")

# addr1 = Address("123 Main St", "Boston", "02101")
# addr2 = Address("123 Main St", "Boston", "02101")
# print(f"\nAddress: {addr1}")
# print(f"  addr1 == addr2: {addr1 == addr2}")
# print(f"  Hashable (can use in set): {hash(addr1) == hash(addr2)}")

# Expected output:
# Products:
#   Product(sku='SKU001', name='Laptop', price=999.99, quantity=2, category='General')
#   Total value: $1999.98
#
# Order: ORD-001
#   Items: 3
#   Subtotal: $1389.93
#   After $100 discount: $1289.93
#
# Address: Address(street='123 Main St', city='Boston', zip_code='02101', country='USA')
#   addr1 == addr2: True
#   Hashable (can use in set): True
