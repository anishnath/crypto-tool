# If, Elif, and Else Statements
# Python uses indentation to define blocks of code.

age = 20

# 1. Simple if statement
if age >= 18:
    print("You are an adult.")

# 2. If-else statement
if age >= 21:
    print("You can drink alcohol (in the US).")
else:
    print("You cannot drink alcohol yet.")

# 3. If-elif-else chain
score = 85

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
elif score >= 60:
    grade = "D"
else:
    grade = "F"

print(f"Score: {score}, Grade: {grade}")

# 4. Nested if statements
is_weekend = True
is_sunny = False

if is_weekend:
    if is_sunny:
        print("Let's go to the beach!")
    else:
        print("Let's watch a movie at home.")
else:
    print("Time to work.")
