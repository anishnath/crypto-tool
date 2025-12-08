# Practical RegEx Examples

import re

# 1. Email validation
print("=== Email Validation ===")
email_pattern = r"^[\w\.-]+@[\w\.-]+\.\w+$"

emails = ["user@example.com", "invalid@", "test.user@domain.co.uk", "@bad.com"]
for email in emails:
    valid = bool(re.match(email_pattern, email))
    print(f"{email}: {'Valid' if valid else 'Invalid'}")
print()

# 2. Phone number extraction
print("=== Phone Numbers ===")
text = "Call me at 555-123-4567 or (555) 987-6543"
pattern = r"\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}"
phones = re.findall(pattern, text)
print(f"Found: {phones}")
print()

# 3. URL extraction
print("=== URLs ===")
text = "Visit https://example.com or http://test.org/page"
pattern = r"https?://[\w\.-]+(?:/[\w\.-]*)*"
urls = re.findall(pattern, text)
print(f"URLs: {urls}")
print()

# 4. Password validation
print("=== Password Validation ===")
def validate_password(pwd):
    checks = {
        "8+ chars": len(pwd) >= 8,
        "uppercase": bool(re.search(r"[A-Z]", pwd)),
        "lowercase": bool(re.search(r"[a-z]", pwd)),
        "digit": bool(re.search(r"\d", pwd)),
        "special": bool(re.search(r"[!@#$%^&*]", pwd))
    }
    return checks

password = "MyP@ss123"
results = validate_password(password)
print(f"Password: {password}")
for check, passed in results.items():
    print(f"  {check}: {'Pass' if passed else 'Fail'}")
print()

# 5. Text cleanup
print("=== Text Cleanup ===")
messy_text = "Hello    World!   How    are   you?"
# Multiple spaces to single
clean = re.sub(r"\s+", " ", messy_text)
print(f"Single spaces: {clean}")

# Remove HTML tags
html = "<p>Hello <b>World</b>!</p>"
text_only = re.sub(r"<[^>]+>", "", html)
print(f"No HTML: {text_only}")
