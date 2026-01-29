# Basic Test Structure with unittest

import unittest

# The functions we want to test
def add(x, y):
    return x + y

def subtract(x, y):
    return x - y

# Test class must inherit from unittest.TestCase
class TestMathOperations(unittest.TestCase):
    """Test cases for basic math operations."""
    
    def test_add(self):
        """Test addition operation."""
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(add(-1, 1), 0)
        self.assertEqual(add(0, 0), 0)
    
    def test_subtract(self):
        """Test subtraction operation."""
        self.assertEqual(subtract(5, 3), 2)
        self.assertEqual(subtract(0, 5), -5)
        self.assertEqual(subtract(10, 10), 0)


# Run the tests
if __name__ == '__main__':
    # This runs all test methods starting with 'test_'
    unittest.main()

# Run with: python prof-testing-basics.py
# Or: python -m unittest prof-testing-basics





