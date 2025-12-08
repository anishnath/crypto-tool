# Exercise: Add Type Hints to a Function
# Write a function with comprehensive type hints that processes user data.
# The function should accept a list of user dictionaries and return statistics.

from typing import List, Dict, Any

# TODO: Implement get_user_stats with proper type hints
def get_user_stats(users: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Calculate statistics from a list of user dictionaries.
    
    Args:
        users: List of user dicts with 'name' (str) and 'age' (int)
    
    Returns:
        Dict with 'total' (int), 'avg_age' (float), 'names' (List[str])
    """
    # TODO: Handle empty list case
    # TODO: Calculate total number of users
    # TODO: Calculate average age
    # TODO: Extract all names
    # TODO: Return dictionary with statistics
    pass


# Test the function
users = [
    {"name": "Alice", "age": 25},
    {"name": "Bob", "age": 30},
    {"name": "Charlie", "age": 35}
]

stats = get_user_stats(users)
print(f"Total users: {stats['total']}")
print(f"Average age: {stats['avg_age']:.1f}")
print(f"Names: {', '.join(stats['names'])}")
