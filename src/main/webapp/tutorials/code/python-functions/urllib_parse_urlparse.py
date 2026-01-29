from urllib.parse import urlparse

# Parse a URL
url = "https://www.example.com:8080/path/to/page?name=John&age=30#section"
parsed = urlparse(url)

print(f"Original URL: {url}\n")
print(f"Scheme: {parsed.scheme}")
print(f"Netloc: {parsed.netloc}")
print(f"Hostname: {parsed.hostname}")
print(f"Port: {parsed.port}")
print(f"Path: {parsed.path}")
print(f"Query: {parsed.query}")
print(f"Fragment: {parsed.fragment}")
