from urllib.request import urlopen

# Fetch content from URL
url = "https://www.example.com"

try:
    with urlopen(url) as response:
        # Read response
        html = response.read()
        
        # Get status code
        print(f"Status: {response.status}")
        print(f"URL: {response.url}")
        
        # Get headers
        print(f"\nContent-Type: {response.headers['Content-Type']}")
        
        # Show first 200 characters
        content = html.decode('utf-8')
        print(f"\nContent preview:\n{content[:200]}...")
        
except Exception as e:
    print(f"Error: {e}")
