# Basic Pattern Matching with re Module

import re

text = "The quick brown fox jumps over the lazy dog"

# re.search(): Finds first match anywhere in string
result = re.search(r"fox", text)
if result:
    print("Found 'fox' at position:", result.start())
    print("Match:", result.group())

# re.match(): Matches only at string start
result = re.match(r"The", text)
if result:
    print("\nMatch at start: 'The'")

result = re.match(r"quick", text)  # Won't match (not at start)
if not result:
    print("No match for 'quick' at start")

# re.findall(): Finds all matches
text2 = "cat bat hat mat"
matches = re.findall(r"at", text2)
print("\nAll matches of 'at':", matches)

# re.finditer(): Returns iterator of Match objects
print("\nUsing finditer:")
for match in re.finditer(r"\w+", text):
    print(f"Word: {match.group()}, Position: {match.start()}-{match.end()}")


# Finding patterns
email_text = "Contact us at support@example.com or sales@test.org"
email_pattern = r"\S+@\S+"
emails = re.findall(email_pattern, email_text)
print("\nFound emails:", emails)

# Matching phone numbers
phone_text = "Call (555) 123-4567 or 555-987-6543"
phone_pattern = r"\(?\d{3}\)?[- ]?\d{3}-\d{4}"
phones = re.findall(phone_pattern, phone_text)
print("Found phones:", phones)





