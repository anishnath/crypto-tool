# Practical While Loop Examples

# 1. Input validation (simulated)
print("=== Input Validation ===")
# Simulating user input - in real code use input()
inputs = ["abc", "-5", "42"]  # Simulated inputs
input_index = 0

valid_number = None
while valid_number is None:
    user_input = inputs[input_index]
    input_index += 1
    print(f"Checking input: '{user_input}'")

    if user_input.isdigit() and int(user_input) > 0:
        valid_number = int(user_input)
        print(f"Valid number: {valid_number}")
    else:
        print("Please enter a positive number.")

print()

# 2. Processing queue/list until empty
print("=== Processing Queue ===")
tasks = ["Send email", "Update database", "Generate report"]

while tasks:  # While list is not empty
    current_task = tasks.pop(0)  # Remove first item
    print(f"Processing: {current_task}")

print("All tasks completed!")

print()

# 3. Retry with maximum attempts
print("=== Retry Logic ===")
max_attempts = 3
attempts = 0
success = False

while attempts < max_attempts and not success:
    attempts += 1
    print(f"Attempt {attempts}...")

    # Simulate: success on 3rd attempt
    if attempts == 3:
        success = True
        print("Operation succeeded!")

if not success:
    print("Max attempts reached. Operation failed.")

print()

# 4. Reading data in chunks (simulated)
print("=== Chunk Processing ===")
data = list(range(1, 11))  # [1, 2, ..., 10]
chunk_size = 3
start = 0

while start < len(data):
    chunk = data[start:start + chunk_size]
    print(f"Processing chunk: {chunk}")
    start += chunk_size

print("All data processed!")
