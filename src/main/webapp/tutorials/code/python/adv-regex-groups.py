# Groups and Capturing

import re

# Simple groups
text = "Contact: John Doe, Phone: (555) 123-4567"

# Capturing groups with parentheses
pattern = r"(\w+) (\w+)"
match = re.search(pattern, text)
if match:
    print("Full match:", match.group(0))  # "John Doe"
    print("Group 1 (first name):", match.group(1))  # "John"
    print("Group 2 (last name):", match.group(2))  # "Doe"
    print("All groups:", match.groups())


# Phone number with groups
phone_pattern = r"\((\d{3})\) (\d{3})-(\d{4})"
match = re.search(phone_pattern, text)
if match:
    area_code, first, last = match.groups()
    print(f"\nPhone number breakdown:")
    print(f"Area code: {area_code}")
    print(f"First part: {first}")
    print(f"Last part: {last}")


# Email parsing with groups
email_text = "Contact support@example.com or sales@test.org"
email_pattern = r"(\w+)@(\w+\.\w+)"
matches = re.findall(email_pattern, email_text)
print("\nEmail parsing:")
for username, domain in matches:
    print(f"Username: {username}, Domain: {domain}")


# Named groups (more readable)
pattern = r"(?P<area>\d{3})-(?P<first>\d{3})-(?P<last>\d{4})"
match = re.search(pattern, "555-123-4567")
if match:
    print("\nNamed groups:")
    print("Area:", match.group('area'))
    print("First:", match.group('first'))
    print("Last:", match.group('last'))
    print("Dict:", match.groupdict())


# Date parsing
date_text = "Today is 2024-01-15 and tomorrow is 2024-01-16"
date_pattern = r"(\d{4})-(\d{2})-(\d{2})"
dates = re.findall(date_pattern, date_text)
print("\nDate parsing:")
for year, month, day in dates:
    print(f"Year: {year}, Month: {month}, Day: {day}")


# Non-capturing groups (?:...)
text2 = "color colour"
# Match both spellings but don't capture the 'u'
pattern = r"colou?r"
matches = re.findall(pattern, text2)
print("\nNon-capturing (both spellings):", matches)

