from collections import deque

# Create a deque (double-ended queue)
dq = deque([1, 2, 3, 4, 5])
print(f"Deque: {dq}")

# Add to right
dq.append(6)
print(f"After append(6): {dq}")

# Add to left
dq.appendleft(0)
print(f"After appendleft(0): {dq}")

# Remove from right
dq.pop()
print(f"After pop(): {dq}")

# Remove from left
dq.popleft()
print(f"After popleft(): {dq}")

# Rotate
dq.rotate(2)  # Rotate right by 2
print(f"After rotate(2): {dq}")
