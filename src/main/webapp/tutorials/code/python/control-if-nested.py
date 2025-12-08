# Nested If Statements

# Checking multiple related conditions
is_weekend = True
weather = "sunny"
has_money = True

print(f"Weekend: {is_weekend}")
print(f"Weather: {weather}")
print(f"Has money: {has_money}")
print()

if is_weekend:
    print("It's the weekend!")

    if weather == "sunny":
        print("  The weather is nice!")

        if has_money:
            print("    Let's go to an amusement park!")
        else:
            print("    Let's have a picnic in the park!")
    elif weather == "rainy":
        print("  It's raining...")
        print("    Let's stay home and watch movies.")
    else:
        print("  Weather is okay.")
        print("    Let's visit a museum.")
else:
    print("It's a weekday.")
    print("  Time to work!")

print()

# Login system example
print("=== Login System ===")
username = "admin"
password = "secret123"
is_active = True

if username == "admin":
    print("Admin account found.")

    if password == "secret123":
        print("  Password correct!")

        if is_active:
            print("    Login successful! Welcome, Admin.")
        else:
            print("    Account is deactivated. Contact support.")
    else:
        print("  Wrong password!")
else:
    print("User not found.")
