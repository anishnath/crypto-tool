# Practical Loop Control Examples

# 1. Input validation with retry limit
print("=== Retry with Limit ===")
valid_passwords = ["secret", "admin123"]
inputs = ["wrong", "bad", "secret"]  # Simulated inputs
max_attempts = 5

for attempt in range(1, max_attempts + 1):
    password = inputs[attempt - 1] if attempt <= len(inputs) else "none"
    print(f"Attempt {attempt}: trying '{password}'")

    if password in valid_passwords:
        print("Access granted!")
        break
else:
    print("Too many failed attempts. Locked out!")

print()

# 2. Processing with filters
print("=== Process Valid Data Only ===")
transactions = [
    {"id": 1, "amount": 100, "status": "completed"},
    {"id": 2, "amount": -50, "status": "pending"},
    {"id": 3, "amount": 200, "status": "completed"},
    {"id": 4, "amount": 75, "status": "failed"},
    {"id": 5, "amount": 150, "status": "completed"},
]

total = 0
for tx in transactions:
    # Skip invalid transactions
    if tx["status"] != "completed":
        print(f"Skipping tx {tx['id']} (status: {tx['status']})")
        continue
    if tx["amount"] < 0:
        print(f"Skipping tx {tx['id']} (negative amount)")
        continue

    total += tx["amount"]
    print(f"Processing tx {tx['id']}: +${tx['amount']}")

print(f"Total processed: ${total}")

print()

# 3. Early exit optimization
print("=== Early Exit for Performance ===")
big_list = list(range(1, 1000001))  # 1 to 1,000,000
target = 42

for i, num in enumerate(big_list):
    if num == target:
        print(f"Found {target} at index {i}")
        print(f"(Only checked {i + 1} items instead of {len(big_list)})")
        break
