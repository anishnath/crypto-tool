# Private Attributes (Double Underscore)

print("=== Private Access (__) ===\n")

# 1. Private with double underscore
print("1. Private attributes (__prefix):")

class SecureAccount:
    def __init__(self, owner, pin, balance):
        self.owner = owner        # Public
        self.__pin = pin          # Private
        self.__balance = balance  # Private

    def verify_pin(self, pin):
        """Only way to use the private __pin."""
        return pin == self.__pin

    def get_balance(self, pin):
        """Access private data after verification."""
        if self.verify_pin(pin):
            return self.__balance
        return "Access denied"

account = SecureAccount("Alice", "1234", 5000)
print(f"   Owner: {account.owner}")
print(f"   Correct PIN: {account.get_balance('1234')}")
print(f"   Wrong PIN: {account.get_balance('0000')}")

# Try to access private attribute directly
try:
    print(account.__balance)
except AttributeError as e:
    print(f"   Direct access failed: {e}")
print()

# 2. Name Mangling explained
print("2. Name Mangling (Python's 'privacy'):")

class Demo:
    def __init__(self):
        self.__secret = "hidden"

d = Demo()

# Python renames __secret to _Demo__secret
print(f"   __dict__: {d.__dict__}")
print(f"   _Demo__secret: {d._Demo__secret}")  # This works!
print()
print("   Python doesn't truly hide private attributes!")
print("   It just renames them: __attr -> _ClassName__attr")
print()

# 3. Why use double underscore?
print("3. Main use: Prevent subclass conflicts:")

class Parent:
    def __init__(self):
        self.__value = "parent"  # Won't clash with child

    def get_value(self):
        return self.__value

class Child(Parent):
    def __init__(self):
        super().__init__()
        self.__value = "child"  # Different attribute!

    def get_child_value(self):
        return self.__value

c = Child()
print(f"   Parent's value: {c.get_value()}")      # "parent"
print(f"   Child's value: {c.get_child_value()}")  # "child"
print(f"   __dict__: {c.__dict__}")
print()

# 4. When to use which?
print("4. Guidelines for access levels:")
print("""
   Public (no prefix):
   - Part of the class's public API
   - Users should use this

   Protected (_single):
   - Implementation detail
   - Subclasses may need it
   - Most "private" attributes should use this

   Private (__double):
   - Prevent accidental override in subclasses
   - Rare! Usually _single is enough
""")

# 5. Practical example
print("5. Practical example:")

class CreditCard:
    def __init__(self, number, cvv):
        self._number = number  # Protected - for internal use
        self.__cvv = cvv       # Private - extra protection

    def get_masked_number(self):
        """Public method to show masked number."""
        return f"****-****-****-{self._number[-4:]}"

    def _validate_transaction(self, amount):
        """Protected - used by subclasses."""
        return amount > 0

    def __verify_cvv(self, cvv):
        """Private - internal verification only."""
        return cvv == self.__cvv

    def make_purchase(self, amount, cvv):
        """Public interface."""
        if self.__verify_cvv(cvv) and self._validate_transaction(amount):
            return f"Purchased ${amount}"
        return "Transaction failed"

card = CreditCard("1234567890123456", "999")
print(f"   Card: {card.get_masked_number()}")
print(f"   Purchase: {card.make_purchase(50, '999')}")
print(f"   Wrong CVV: {card.make_purchase(50, '000')}")
