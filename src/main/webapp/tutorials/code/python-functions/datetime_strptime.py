
from datetime import datetime

date_string = "25 December, 2025"
print("Date String:", date_string)

# Convert string to datetime object
date_object = datetime.strptime(date_string, "%d %B, %Y")

print("Date Object:", date_object)
print("Type:", type(date_object))
