# Python Dates
# A date in Python is not a data type of its own, but we can import a module named datetime.

import datetime

# 1. Get Current Date
x = datetime.datetime.now()
print(f"Current Date/Time: {x}")

# 2. Date Output
print(f"Year: {x.year}")
print(f"Day of week: {x.strftime('%A')}")

# 3. Creating Date Objects
# datetime(year, month, day)
my_date = datetime.datetime(2020, 5, 17)
print(f"Created Date: {my_date}")

# 4. Formatting Dates (strftime)
# %B = Month name, %d = Day of month, %Y = Year
formatted_date = x.strftime("%B %d, %Y")
print(f"Formatted: {formatted_date}")
