# Dictionary of Dictionaries - Hierarchical Data

# Perfect for config files, user profiles, database-like structures

# 1. Basic nested dictionary
print("=== Dictionary of Dictionaries ===")
company = {
    "engineering": {
        "manager": "Alice",
        "employees": 25,
        "budget": 500000
    },
    "marketing": {
        "manager": "Bob",
        "employees": 15,
        "budget": 300000
    },
    "sales": {
        "manager": "Charlie",
        "employees": 30,
        "budget": 400000
    }
}

print("Departments:")
for dept, info in company.items():
    print(f"  {dept}: {info['employees']} employees, managed by {info['manager']}")
print()

# 2. Deep access
print("=== Deep Access ===")
print(f"Engineering manager: {company['engineering']['manager']}")
print(f"Marketing budget: ${company['marketing']['budget']:,}")
print()

# 3. Safe deep access with get()
print("=== Safe Deep Access ===")
# Chained get() for safety
hr_manager = company.get("hr", {}).get("manager", "Not assigned")
print(f"HR manager: {hr_manager}")

# Engineering location (doesn't exist)
eng_location = company.get("engineering", {}).get("location", "HQ")
print(f"Engineering location: {eng_location}")
print()

# 4. Modifying nested data
print("=== Modifying Nested Data ===")
# Update a value
company["engineering"]["budget"] = 550000
print(f"New engineering budget: ${company['engineering']['budget']:,}")

# Add nested key
company["engineering"]["location"] = "Building A"
print(f"Engineering location: {company['engineering']['location']}")

# Add new department
company["hr"] = {"manager": "Diana", "employees": 5, "budget": 100000}
print(f"Added HR department: {company['hr']}")
print()

# 5. Iterating with nested values
print("=== Total Budget Calculation ===")
total_budget = sum(dept["budget"] for dept in company.values())
total_employees = sum(dept["employees"] for dept in company.values())
print(f"Total budget: ${total_budget:,}")
print(f"Total employees: {total_employees}")
print()

# 6. Config file pattern
print("=== Config Pattern ===")
config = {
    "database": {
        "host": "localhost",
        "port": 5432,
        "name": "myapp"
    },
    "cache": {
        "enabled": True,
        "ttl": 3600
    },
    "logging": {
        "level": "INFO",
        "file": "/var/log/app.log"
    }
}

# Access config values
db_host = config["database"]["host"]
cache_enabled = config["cache"]["enabled"]
print(f"Database host: {db_host}")
print(f"Cache enabled: {cache_enabled}")
