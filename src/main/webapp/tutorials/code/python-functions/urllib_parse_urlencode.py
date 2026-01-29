from urllib.parse import urlencode

# Encode dictionary to query string
params = {
    'name': 'John Doe',
    'age': 30,
    'city': 'New York'
}

encoded = urlencode(params)
print(f"Encoded: {encoded}")

# Use in URL
url = f"https://example.com/api?{encoded}"
print(f"Full URL: {url}")

# Encode with special characters
data = {'message': 'Hello World!', 'email': 'user@example.com'}
print(f"\nWith special chars: {urlencode(data)}")
