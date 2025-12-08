# Assignment Operators with Strings

# String concatenation with +=
message = "Hello"
print(f"Initial: {message}")

message += " "
message += "World"
print(f"After +=: {message}")

message += "!"
print(f"Final: {message}")

print()

# String repetition with *=
separator = "-"
print(f"Initial separator: '{separator}'")

separator *= 20
print(f"After *= 20: '{separator}'")

print()

# Building strings in a loop
result = ""
for i in range(1, 6):
    result += str(i)
    print(f"Loop {i}: result = '{result}'")

print()

# Common pattern: Building a formatted string
items = ["apple", "banana", "cherry"]
output = "Shopping list: "
for item in items:
    output += item + ", "
output = output[:-2]  # Remove trailing ", "
print(output)
