# Method Chaining and Special Patterns

print("=== Method Chaining ===\n")

# 1. Method chaining - return self
print("1. Basic method chaining:")

class StringBuilder:
    def __init__(self):
        self.parts = []

    def append(self, text):
        self.parts.append(text)
        return self  # Return self for chaining!

    def append_line(self, text):
        self.parts.append(text + '\n')
        return self

    def build(self):
        return ''.join(self.parts)

# Chain multiple calls
result = (StringBuilder()
    .append("Hello ")
    .append("World")
    .append_line("!")
    .append("Python is ")
    .append("awesome")
    .build())

print(f"   Result:\n{result}")
print()

# 2. Fluent interface pattern
print("2. Fluent interface (query builder):")

class QueryBuilder:
    def __init__(self, table):
        self.table = table
        self._select = '*'
        self._where = []
        self._order = None
        self._limit = None

    def select(self, *columns):
        self._select = ', '.join(columns)
        return self

    def where(self, condition):
        self._where.append(condition)
        return self

    def order_by(self, column, desc=False):
        self._order = f"{column} {'DESC' if desc else 'ASC'}"
        return self

    def limit(self, n):
        self._limit = n
        return self

    def build(self):
        sql = f"SELECT {self._select} FROM {self.table}"
        if self._where:
            sql += " WHERE " + " AND ".join(self._where)
        if self._order:
            sql += f" ORDER BY {self._order}"
        if self._limit:
            sql += f" LIMIT {self._limit}"
        return sql

# Build query with chaining
query = (QueryBuilder("users")
    .select("name", "email", "age")
    .where("age > 18")
    .where("active = true")
    .order_by("name")
    .limit(10)
    .build())

print(f"   {query}")
print()

# 3. Builder pattern
print("3. Builder pattern:")

class Pizza:
    def __init__(self):
        self.size = "medium"
        self.crust = "regular"
        self.toppings = []

    def set_size(self, size):
        self.size = size
        return self

    def set_crust(self, crust):
        self.crust = crust
        return self

    def add_topping(self, topping):
        self.toppings.append(topping)
        return self

    def __str__(self):
        toppings = ", ".join(self.toppings) if self.toppings else "plain"
        return f"{self.size} {self.crust} pizza with {toppings}"

pizza = (Pizza()
    .set_size("large")
    .set_crust("thin")
    .add_topping("mushrooms")
    .add_topping("pepperoni")
    .add_topping("olives"))

print(f"   Order: {pizza}")
print()

# 4. Method comparison summary
print("4. Method Types Summary:")
print("""
   Instance Method:
   - def method(self): ...
   - Has access to self (instance)
   - Most common type

   Class Method:
   - @classmethod
   - def method(cls): ...
   - Has access to cls (class)
   - Good for alternative constructors

   Static Method:
   - @staticmethod
   - def method(): ...
   - No self or cls
   - Like regular function in class namespace
""")

# 5. Choosing the right method type
print("5. Which method type to use?")
print("""
   Use instance method when:
   - You need self (instance data)
   - Method operates on instance state

   Use class method when:
   - You need cls (class itself)
   - Alternative constructor
   - Factory methods
   - Works with inheritance

   Use static method when:
   - Don't need self or cls
   - Utility function related to class
   - Could be module function but belongs with class
""")
