# If-Elif-Else Chain

# Use elif when you have multiple conditions to check
# Only ONE block will execute

score = 78

print(f"Score: {score}")
print()

if score >= 90:
    grade = "A"
    message = "Excellent!"
elif score >= 80:
    grade = "B"
    message = "Good job!"
elif score >= 70:
    grade = "C"
    message = "Satisfactory"
elif score >= 60:
    grade = "D"
    message = "Needs improvement"
else:
    grade = "F"
    message = "Please see the teacher"

print(f"Grade: {grade}")
print(f"Message: {message}")

print()

# Day of the week example
day = 3  # 1 = Monday, 7 = Sunday

if day == 1:
    day_name = "Monday"
elif day == 2:
    day_name = "Tuesday"
elif day == 3:
    day_name = "Wednesday"
elif day == 4:
    day_name = "Thursday"
elif day == 5:
    day_name = "Friday"
elif day == 6:
    day_name = "Saturday"
elif day == 7:
    day_name = "Sunday"
else:
    day_name = "Invalid day"

print(f"Day {day} is {day_name}")

print()

# Age category example
age = 25

if age < 0:
    category = "Invalid age"
elif age < 13:
    category = "Child"
elif age < 20:
    category = "Teenager"
elif age < 60:
    category = "Adult"
else:
    category = "Senior"

print(f"Age {age}: {category}")
