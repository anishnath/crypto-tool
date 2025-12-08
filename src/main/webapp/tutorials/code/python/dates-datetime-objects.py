# Creating and Using datetime Objects

from datetime import datetime, date, time

# 1. Get current date and time
print("=== Current Date/Time ===")
now = datetime.now()
print(f"Current datetime: {now}")
print(f"Today's date: {date.today()}")
print()

# 2. Access individual components
print("=== Datetime Components ===")
print(f"Year: {now.year}")
print(f"Month: {now.month}")
print(f"Day: {now.day}")
print(f"Hour: {now.hour}")
print(f"Minute: {now.minute}")
print(f"Second: {now.second}")
print(f"Microsecond: {now.microsecond}")
print()

# 3. Creating specific dates
print("=== Creating Dates ===")
# Create a date: date(year, month, day)
birthday = date(1990, 6, 15)
print(f"Birthday: {birthday}")

# Create a datetime: datetime(year, month, day, hour, minute, second)
event = datetime(2024, 12, 31, 23, 59, 59)
print(f"Event: {event}")

# Create just a time: time(hour, minute, second)
alarm = time(7, 30, 0)
print(f"Alarm: {alarm}")
print()

# 4. Useful date properties
print("=== Date Properties ===")
print(f"Weekday (0=Mon): {now.weekday()}")
print(f"ISO weekday (1=Mon): {now.isoweekday()}")
print(f"Day of year: {now.timetuple().tm_yday}")
