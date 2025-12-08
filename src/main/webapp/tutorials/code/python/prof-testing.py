import unittest

# The function we want to test
def add(x, y):
    return x + y

def divide(x, y):
    if y == 0:
        raise ValueError("Cannot divide by zero")
    return x / y

# The test class must inherit from unittest.TestCase
class TestMathOperations(unittest.TestCase):

    def test_add(self):
        self.assertEqual(add(3, 5), 8)
        self.assertEqual(add(-1, 1), 0)
        self.assertEqual(add(-1, -1), -2)

    def test_divide(self):
        self.assertEqual(divide(10, 2), 5)
        self.assertEqual(divide(5, 2), 2.5)
        
        # Testing for exceptions
        with self.assertRaises(ValueError):
            divide(10, 0)

if __name__ == '__main__':
    # This runs the tests
    unittest.main()
