# Reading and Writing JSON Files

import json
import os

# 1. Write JSON to file with dump()
print("=== json.dump() - Write to File ===")
config = {
    "app_name": "MyApp",
    "version": "1.0.0",
    "debug": True,
    "database": {
        "host": "localhost",
        "port": 5432,
        "name": "mydb"
    },
    "features": ["auth", "logging", "cache"]
}

with open("config.json", "w") as f:
    json.dump(config, f, indent=2)

print("Wrote config.json")
with open("config.json", "r") as f:
    print(f.read())
print()

# 2. Read JSON from file with load()
print("=== json.load() - Read from File ===")
with open("config.json", "r") as f:
    loaded = json.load(f)

print(f"Type: {type(loaded)}")
print(f"App: {loaded['app_name']}")
print(f"DB Host: {loaded['database']['host']}")
print(f"Features: {loaded['features']}")
print()

# 3. Updating JSON files
print("=== Update JSON File ===")
with open("config.json", "r") as f:
    config = json.load(f)

# Modify
config["version"] = "1.1.0"
config["features"].append("api")

# Write back
with open("config.json", "w") as f:
    json.dump(config, f, indent=2)

# Verify
with open("config.json", "r") as f:
    print(f.read())
print()

# 4. Working with JSON Lines (JSONL)
print("=== JSON Lines Format ===")
events = [
    {"timestamp": "2024-01-01", "event": "login", "user": "alice"},
    {"timestamp": "2024-01-02", "event": "purchase", "user": "bob"},
    {"timestamp": "2024-01-03", "event": "logout", "user": "alice"}
]

# Write JSONL (one JSON object per line)
with open("events.jsonl", "w") as f:
    for event in events:
        f.write(json.dumps(event) + "\n")

# Read JSONL
print("Events from JSONL:")
with open("events.jsonl", "r") as f:
    for line in f:
        event = json.loads(line)
        print(f"  {event['timestamp']}: {event['user']} - {event['event']}")
print()

# 5. Safe loading with error handling
print("=== Safe JSON Loading ===")
def load_json_safe(filename, default=None):
    """Load JSON file with error handling."""
    try:
        with open(filename, "r") as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"File not found: {filename}")
        return default
    except json.JSONDecodeError as e:
        print(f"Invalid JSON in {filename}: {e}")
        return default

# Test with valid file
result = load_json_safe("config.json", {})
print(f"Loaded: {result['app_name']}")

# Test with missing file
result = load_json_safe("missing.json", {"default": True})
print(f"Default: {result}")

# Cleanup
os.remove("config.json")
os.remove("events.jsonl")
print("\n(Cleaned up files)")
