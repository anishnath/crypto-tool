import random

# Shuffle a list
cards = ["Ace", "King", "Queen", "Jack", "10"]
print(f"Original: {cards}")

random.shuffle(cards)
print(f"Shuffled: {cards}")

# Shuffle again
random.shuffle(cards)
print(f"Shuffled again: {cards}")

# Note: shuffle() modifies the list in-place
