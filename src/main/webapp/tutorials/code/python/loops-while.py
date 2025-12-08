# While Loops
# Executes a set of statements as long as a condition is true.

# 1. Basic while loop
count = 1
print("Counting up:")
while count <= 5:
    print(count)
    count += 1 # IMPORTANT: Increment to avoid infinite loop

# 2. While loop with user input simulation
# In a real app, you might use input(), but for this demo we'll simulate it
password = ""
attempts = 0
correct_password = "secret"

print("\nLogin Attempt:")
while password != correct_password and attempts < 3:
    attempts += 1
    # Simulating different inputs
    if attempts == 1:
        password = "123"
    elif attempts == 2:
        password = "secret"
    
    print(f"Attempt {attempts}: Trying '{password}'...")

if password == correct_password:
    print("Access Granted!")
else:
    print("Locked out.")
