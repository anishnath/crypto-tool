
# Named placeholders
txt1 = "My name is {fname}, I'm {age}".format(fname="John", age=36)
print(txt1)

# Numbered placeholders
txt2 = "My name is {0}, I'm {1}".format("John", 36)
print(txt2)

# Empty placeholders (auto-numbered)
txt3 = "My name is {}, I'm {}".format("John", 36)
print(txt3)

# Formatting numbers
print("Cost: {:.2f}".format(45))
print("Binary: {:b}".format(12))
print("Percentage: {:.0%}".format(0.25))
