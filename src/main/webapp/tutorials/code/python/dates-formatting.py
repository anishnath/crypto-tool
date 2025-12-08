# Formatting Dates with strftime()

from datetime import datetime

now = datetime.now()
print(f"Original datetime: {now}")
print()

# Common format codes
print("=== Date Format Codes ===")
print(f"%Y - 4-digit year: {now.strftime('%Y')}")
print(f"%y - 2-digit year: {now.strftime('%y')}")
print(f"%m - Month (01-12): {now.strftime('%m')}")
print(f"%d - Day (01-31): {now.strftime('%d')}")
print(f"%B - Full month: {now.strftime('%B')}")
print(f"%b - Abbrev month: {now.strftime('%b')}")
print(f"%A - Full weekday: {now.strftime('%A')}")
print(f"%a - Abbrev weekday: {now.strftime('%a')}")
print()

print("=== Time Format Codes ===")
print(f"%H - Hour 24h (00-23): {now.strftime('%H')}")
print(f"%I - Hour 12h (01-12): {now.strftime('%I')}")
print(f"%M - Minute (00-59): {now.strftime('%M')}")
print(f"%S - Second (00-59): {now.strftime('%S')}")
print(f"%p - AM/PM: {now.strftime('%p')}")
print()

print("=== Common Formats ===")
print(f"ISO format: {now.strftime('%Y-%m-%d')}")
print(f"US format: {now.strftime('%m/%d/%Y')}")
print(f"UK format: {now.strftime('%d/%m/%Y')}")
print(f"Full date: {now.strftime('%B %d, %Y')}")
print(f"Time 24h: {now.strftime('%H:%M:%S')}")
print(f"Time 12h: {now.strftime('%I:%M %p')}")
print(f"Timestamp: {now.strftime('%Y-%m-%d %H:%M:%S')}")
