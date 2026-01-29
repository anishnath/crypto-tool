# Substitution with re.sub

import re

text = "Contact: email@example.com or sales@test.org"

# Basic substitution
new_text = re.sub(r"@", "[at]", text)
print("Basic substitution:")
print(new_text)

# Using groups in replacement
phone_text = "Call (555) 123-4567"
# Reorder: (area) first-last -> area-first-last
new_phone = re.sub(r"\((\d{3})\) (\d{3})-(\d{4})", r"\1-\2-\3", phone_text)
print("\nReordering with groups:")
print(new_phone)

# Using named groups
email_text = "Contact support@example.com"
new_email = re.sub(r"(?P<user>\w+)@(?P<domain>\S+)", r"\g<user>[at]\g<domain>", email_text)
print("\nNamed groups in replacement:")
print(new_email)

# Date format conversion
dates_text = "2024-01-15 and 2024-12-25"
# Convert YYYY-MM-DD to MM/DD/YYYY
new_dates = re.sub(r"(\d{4})-(\d{2})-(\d{2})", r"\2/\3/\1", dates_text)
print("\nDate format conversion:")
print(new_dates)

# Function as replacement
def mask_email(match):
    """Mask email addresses."""
    email = match.group(0)
    parts = email.split('@')
    masked = parts[0][0] + '***@' + parts[1]
    return masked

emails_text = "Contact alice@example.com or bob@test.org"
masked = re.sub(r"\S+@\S+", mask_email, emails_text)
print("\nFunction replacement (masking):")
print(masked)

# Count parameter (replace first N occurrences)
text3 = "cat bat cat mat cat"
replaced = re.sub(r"cat", "dog", text3, count=2)  # Replace first 2
print("\nLimited replacements:")
print(replaced)

# Practical: Cleaning phone numbers
phone_numbers = "(555) 123-4567, 555-987-6543, (888) 555-0000"
# Normalize to: 555-123-4567
normalized = re.sub(r"\(?(\d{3})\)?[- ]?(\d{3})-(\d{4})", r"\1-\2-\3", phone_numbers)
print("\nPhone number normalization:")
print(normalized)





