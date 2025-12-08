# Exercise: Shopping Cart with Different Method Types
# Complete the ShoppingCart class with the specified methods

class ShoppingCart:
    """Shopping cart demonstrating different method types."""

    def __init__(self):
        self.items = []

    # 1. Instance method: add_item(name, price)
    #    - Appends {'name': name, 'price': price} to self.items
    #    - Returns self for method chaining
    # Your code here:


    # 2. Instance method: total()
    #    - Returns the sum of all item prices
    # Your code here:


    # 3. Class method: from_list(items)
    #    - Creates a new cart from a list of (name, price) tuples
    #    - Use @classmethod decorator
    # Your code here:


    # 4. Static method: format_price(amount)
    #    - Returns string formatted as "$X.XX"
    #    - Use @staticmethod decorator
    # Your code here:



# Test your implementation:

# Test instance methods with chaining
cart = ShoppingCart()
# cart.add_item("Apple", 1.50).add_item("Bread", 2.99).add_item("Milk", 3.49)
# print(f"Total: {ShoppingCart.format_price(cart.total())}")

# Test class method (alternative constructor)
# items = [("Coffee", 5.99), ("Sugar", 2.50)]
# cart2 = ShoppingCart.from_list(items)
# print(f"Cart2 Total: {ShoppingCart.format_price(cart2.total())}")
