# Exercise: Extract Phone Numbers
# Create a function that extracts phone numbers from text.
# Handle both formats: (123) 456-7890 and 123-456-7890.

import re

# TODO: Implement the extract_phones function
def extract_phones(text):
    """
    Extract phone numbers in formats (123) 456-7890 or 123-456-7890.
    
    Args:
        text: String containing phone numbers
    
    Returns:
        List of found phone numbers
    """
    # TODO: Define pattern that matches both formats:
    # - (123) 456-7890 (area code in parentheses, optional space/dash)
    # - 123-456-7890 (all numbers with dashes)
    # TODO: Use re.findall() to find all matches
    # TODO: Return the list of matches
    pass


# Test the function
text = """
Contact us at (555) 123-4567 or 555-987-6543.
Our office is at 123-456-7890.
Call (888) 555-0000 for support.
"""

phones = extract_phones(text)
print("Found phone numbers:")
for phone in phones:
    print(f"  - {phone}")
