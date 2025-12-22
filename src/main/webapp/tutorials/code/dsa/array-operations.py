# Array Operations - The Essentials
# Understanding O(1) access vs O(n) operations

# Game leaderboard example
leaderboard = ["Alice", "Bob", "Charlie", "David", "Eve"]

print("=== Array Access: O(1) ===")
print(f"Rank 1 (index 0): {leaderboard[0]}")  # Instant!
print(f"Rank 3 (index 2): {leaderboard[2]}")  # Also instant!
print(f"Rank 5 (index 4): {leaderboard[4]}")  # Still instant!
print("✅ Direct index access = O(1) time\n")

print("=== Array Search: O(n) ===")
def find_player_rank(leaderboard, name):
    """Find a player's rank by name - must check each element"""
    for i, player in enumerate(leaderboard):
        if player == name:
            return i + 1  # Rank is 1-indexed
    return -1  # Not found

rank = find_player_rank(leaderboard, "Charlie")
print(f"Charlie's rank: {rank}")
print("❌ Search by value = O(n) time (worst case)\n")

print("=== Array Insert: O(n) ===")
print(f"Before insert: {leaderboard}")
# Insert "Frank" at rank 2 (index 1)
leaderboard.insert(1, "Frank")  # Shifts Bob, Charlie, David, Eve
print(f"After insert:  {leaderboard}")
print("❌ Insert = O(n) time (must shift elements)\n")

print("=== Array Delete: O(n) ===")
print(f"Before delete: {leaderboard}")
del leaderboard[1]  # Remove Frank, shifts everyone back
print(f"After delete:  {leaderboard}")
print("❌ Delete = O(n) time (must shift elements)\n")

print("=== Key Takeaway ===")
print("Arrays are great for:")
print("  ✅ Fast access by index: O(1)")
print("  ✅ Iterating through all elements: O(n)")
print("\nArrays are slow for:")
print("  ❌ Inserting/deleting (except at end): O(n)")
print("  ❌ Searching by value: O(n)")
