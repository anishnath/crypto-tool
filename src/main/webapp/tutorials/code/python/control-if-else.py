# If-Else Statement

# Either one block or the other executes - never both!
temperature = 25

print(f"Temperature: {temperature}°C")
print()

if temperature >= 30:
    print("It's hot outside!")
    print("Wear light clothes.")
else:
    print("It's not too hot.")
    print("Enjoy the weather!")

print()

# Another example with numbers
number = 7

if number % 2 == 0:
    print(f"{number} is even")
else:
    print(f"{number} is odd")

print()

# Checking string conditions
username = "admin"

if username == "admin":
    print("Welcome, Administrator!")
    print("You have full access.")
else:
    print(f"Welcome, {username}!")
    print("You have limited access.")

print()

# Checking list emptiness
shopping_cart = []

if shopping_cart:
    print(f"Your cart has {len(shopping_cart)} items")
else:
    print("Your cart is empty!")
