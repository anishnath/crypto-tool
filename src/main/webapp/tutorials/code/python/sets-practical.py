# Practical Set Use Cases

# 1. Remove duplicates from a list
print("=== Remove Duplicates ===")
names = ["Alice", "Bob", "Alice", "Charlie", "Bob", "David"]
unique_names = list(set(names))
print(f"Original: {names}")
print(f"Unique: {unique_names}")
print()

# 2. Find common elements between lists
print("=== Common Elements ===")
list1 = [1, 2, 3, 4, 5]
list2 = [4, 5, 6, 7, 8]
common = list(set(list1) & set(list2))
print(f"List 1: {list1}")
print(f"List 2: {list2}")
print(f"Common: {common}")
print()

# 3. Find elements in first list but not second
print("=== Elements Only in First ===")
only_in_first = list(set(list1) - set(list2))
print(f"Only in list1: {only_in_first}")
print()

# 4. Check membership (O(1) vs O(n) for lists)
print("=== Fast Membership Testing ===")
valid_users = {"alice", "bob", "charlie", "david"}
username = "bob"
if username in valid_users:  # O(1) lookup!
    print(f"'{username}' is a valid user")
print()

# 5. Count unique items
print("=== Count Unique Items ===")
text = "hello world"
unique_chars = set(text)
print(f"Text: '{text}'")
print(f"Unique characters: {unique_chars}")
print(f"Count: {len(unique_chars)}")
print()

# 6. Compare two datasets
print("=== Compare Datasets ===")
yesterday_users = {"alice", "bob", "charlie"}
today_users = {"bob", "david", "eve"}

new_users = today_users - yesterday_users
lost_users = yesterday_users - today_users
returning_users = yesterday_users & today_users

print(f"Yesterday: {yesterday_users}")
print(f"Today: {today_users}")
print(f"New today: {new_users}")
print(f"Lost today: {lost_users}")
print(f"Returning: {returning_users}")
print()

# 7. Filter with sets
print("=== Efficient Filtering ===")
all_items = ["apple", "banana", "cherry", "date", "elderberry"]
banned = {"banana", "date"}
allowed = [item for item in all_items if item not in banned]
print(f"All items: {all_items}")
print(f"Banned: {banned}")
print(f"Allowed: {allowed}")
