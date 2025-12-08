# Practical Argument Patterns

# 1. Building flexible APIs
print("=== Flexible API Functions ===")
def create_element(tag, content="", **attributes):
    """Create an HTML-like element string."""
    attrs = " ".join(f'{k}="{v}"' for k, v in attributes.items())
    if attrs:
        return f"<{tag} {attrs}>{content}</{tag}>"
    return f"<{tag}>{content}</{tag}>"

print(create_element("p", "Hello World"))
print(create_element("a", "Click here", href="https://example.com"))
print(create_element("div", "Content", id="main", class_="container"))
print()

# 2. Configuration functions
print("=== Configuration Pattern ===")
def configure_app(name, debug=False, log_level="INFO", **settings):
    """Configure an application with various options."""
    config = {
        "name": name,
        "debug": debug,
        "log_level": log_level,
        **settings  # Merge additional settings
    }
    return config

config = configure_app(
    "MyApp",
    debug=True,
    log_level="DEBUG",
    database="postgresql",
    cache="redis"
)
print(f"Config: {config}")
print()

# 3. Decorator-friendly functions
print("=== Wrapper Functions ===")
def log_call(func):
    """A simple logging wrapper."""
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__} with args={args}, kwargs={kwargs}")
        result = func(*args, **kwargs)
        print(f"Returned: {result}")
        return result
    return wrapper

@log_call
def add(a, b):
    return a + b

add(3, 5)
add(x=10, y=20)  # This would error since add expects a, b
print()

# 4. Method chaining support
print("=== Chaining Pattern ===")
class QueryBuilder:
    def __init__(self):
        self.conditions = []

    def where(self, field, value=None, **kwargs):
        """Add conditions flexibly."""
        if value is not None:
            self.conditions.append(f"{field}={value}")
        for k, v in kwargs.items():
            self.conditions.append(f"{k}={v}")
        return self  # Enable chaining

    def build(self):
        return " AND ".join(self.conditions)

query = QueryBuilder().where("age", 25).where(city="NYC", active=True).build()
print(f"Query: {query}")
