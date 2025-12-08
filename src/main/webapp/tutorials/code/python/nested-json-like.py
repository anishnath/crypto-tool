# Working with JSON-like Nested Data

# This is what you'll typically receive from APIs

# 1. Complex nested structure (API response pattern)
print("=== JSON-like API Response ===")
api_response = {
    "status": "success",
    "data": {
        "users": [
            {
                "id": 1,
                "name": "Alice",
                "email": "alice@example.com",
                "posts": [
                    {"id": 101, "title": "First Post", "likes": 42},
                    {"id": 102, "title": "Second Post", "likes": 28}
                ]
            },
            {
                "id": 2,
                "name": "Bob",
                "email": "bob@example.com",
                "posts": [
                    {"id": 201, "title": "Hello World", "likes": 15}
                ]
            }
        ],
        "total": 2
    }
}

print(f"Status: {api_response['status']}")
print(f"Total users: {api_response['data']['total']}")
print()

# 2. Navigating deep structures
print("=== Deep Navigation ===")
# Get first user's name
first_user = api_response['data']['users'][0]['name']
print(f"First user: {first_user}")

# Get first user's second post title
post_title = api_response['data']['users'][0]['posts'][1]['title']
print(f"Alice's second post: {post_title}")
print()

# 3. Extracting specific data
print("=== Extracting Data ===")
# Get all user emails
emails = [user['email'] for user in api_response['data']['users']]
print(f"All emails: {emails}")

# Get all post titles
all_posts = []
for user in api_response['data']['users']:
    for post in user['posts']:
        all_posts.append(post['title'])
print(f"All post titles: {all_posts}")
print()

# 4. Finding data in nested structures
print("=== Finding Data ===")
# Find user by ID
target_id = 2
found_user = None
for user in api_response['data']['users']:
    if user['id'] == target_id:
        found_user = user
        break

if found_user:
    print(f"Found user {target_id}: {found_user['name']}")
print()

# 5. Aggregating nested data
print("=== Aggregating Data ===")
# Total likes across all posts
total_likes = 0
for user in api_response['data']['users']:
    for post in user['posts']:
        total_likes += post['likes']
print(f"Total likes: {total_likes}")

# Or with comprehension
total_likes = sum(
    post['likes']
    for user in api_response['data']['users']
    for post in user['posts']
)
print(f"Total likes (comprehension): {total_likes}")
print()

# 6. Transforming JSON data
print("=== Transforming Data ===")
# Create a simpler structure
simple_users = [
    {
        "name": user["name"],
        "post_count": len(user["posts"]),
        "total_likes": sum(p["likes"] for p in user["posts"])
    }
    for user in api_response["data"]["users"]
]
print("Simplified user data:")
for u in simple_users:
    print(f"  {u['name']}: {u['post_count']} posts, {u['total_likes']} likes")
