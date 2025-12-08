# Date Arithmetic with timedelta

from datetime import datetime, date, timedelta

today = date.today()
now = datetime.now()
print(f"Today: {today}")
print(f"Now: {now}")
print()

# 1. Create timedelta objects
print("=== Creating timedeltas ===")
one_day = timedelta(days=1)
one_week = timedelta(weeks=1)
custom = timedelta(days=5, hours=3, minutes=30)
print(f"One day: {one_day}")
print(f"One week: {one_week}")
print(f"Custom (5d 3h 30m): {custom}")
print()

# 2. Adding time to dates
print("=== Adding Time ===")
tomorrow = today + one_day
print(f"Tomorrow: {tomorrow}")
next_week = today + one_week
print(f"Next week: {next_week}")
future = now + timedelta(hours=5, minutes=30)
print(f"In 5.5 hours: {future}")
print()

# 3. Subtracting time from dates
print("=== Subtracting Time ===")
yesterday = today - one_day
print(f"Yesterday: {yesterday}")
last_month = today - timedelta(days=30)
print(f"30 days ago: {last_month}")
print()

# 4. Difference between dates
print("=== Date Differences ===")
birthday = date(2024, 12, 25)
days_until = birthday - today
print(f"Days until Dec 25, 2024: {days_until.days}")

# Calculate age
birth = date(1990, 6, 15)
age_days = (today - birth).days
print(f"Age in days: {age_days}")
print(f"Age in years (approx): {age_days // 365}")
