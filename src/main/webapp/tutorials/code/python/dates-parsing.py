# Parsing Strings to Dates with strptime()

from datetime import datetime

# strptime() = "string parse time"
# Converts string -> datetime using format codes

print("=== Parsing Date Strings ===")

# Parse ISO format
date_str = "2024-03-15"
parsed = datetime.strptime(date_str, "%Y-%m-%d")
print(f"'{date_str}' -> {parsed}")

# Parse US format
us_date = "03/15/2024"
parsed = datetime.strptime(us_date, "%m/%d/%Y")
print(f"'{us_date}' -> {parsed}")

# Parse UK format
uk_date = "15/03/2024"
parsed = datetime.strptime(uk_date, "%d/%m/%Y")
print(f"'{uk_date}' -> {parsed}")
print()

print("=== Parsing with Time ===")

# Parse datetime
timestamp = "2024-03-15 14:30:00"
parsed = datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S")
print(f"'{timestamp}' -> {parsed}")

# Parse 12-hour format
time_str = "03:30 PM"
parsed = datetime.strptime(time_str, "%I:%M %p")
print(f"'{time_str}' -> {parsed.strftime('%H:%M')}")
print()

print("=== Parsing Natural Dates ===")

# Full month name
natural = "March 15, 2024"
parsed = datetime.strptime(natural, "%B %d, %Y")
print(f"'{natural}' -> {parsed.date()}")

# With weekday
with_day = "Friday, March 15, 2024"
parsed = datetime.strptime(with_day, "%A, %B %d, %Y")
print(f"'{with_day}' -> {parsed.date()}")
print()

print("=== Convert Between Formats ===")
# Parse one format, output another
input_date = "15-Mar-2024"
parsed = datetime.strptime(input_date, "%d-%b-%Y")
output = parsed.strftime("%Y/%m/%d")
print(f"'{input_date}' -> '{output}'")
