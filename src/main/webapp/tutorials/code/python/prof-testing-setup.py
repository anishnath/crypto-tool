# setUp and tearDown Methods

import unittest

class Calculator:
    """Simple calculator class for testing."""
    def __init__(self):
        self.history = []
    
    def add(self, a, b):
        result = a + b
        self.history.append(f"{a} + {b} = {result}")
        return result
    
    def clear_history(self):
        self.history = []


class TestCalculator(unittest.TestCase):
    """Tests using setUp and tearDown."""
    
    def setUp(self):
        """Set up test fixtures before each test method."""
        # This runs BEFORE each test method
        self.calc = Calculator()
        print("setUp: Creating new Calculator instance")
    
    def tearDown(self):
        """Clean up after each test method."""
        # This runs AFTER each test method
        self.calc.clear_history()
        print("tearDown: Clearing calculator history")
    
    def test_add_positive(self):
        """Test addition with positive numbers."""
        result = self.calc.add(2, 3)
        self.assertEqual(result, 5)
        self.assertEqual(len(self.calc.history), 1)
    
    def test_add_negative(self):
        """Test addition with negative numbers."""
        # Each test gets a fresh Calculator instance from setUp
        result = self.calc.add(-2, -3)
        self.assertEqual(result, -5)
        # History is fresh for this test
        self.assertEqual(len(self.calc.history), 1)
    
    def test_add_zero(self):
        """Test addition with zero."""
        result = self.calc.add(5, 0)
        self.assertEqual(result, 5)


# setUpClass and tearDownClass (run once for the class)
class TestDatabase(unittest.TestCase):
    """Example using class-level setup."""
    
    @classmethod
    def setUpClass(cls):
        """Run once before all tests in this class."""
        print("setUpClass: Connecting to database")
        cls.db_connection = "connected"  # Simulated connection
    
    @classmethod
    def tearDownClass(cls):
        """Run once after all tests in this class."""
        print("tearDownClass: Closing database connection")
        cls.db_connection = None
    
    def test_query1(self):
        """First test."""
        self.assertEqual(self.db_connection, "connected")
    
    def test_query2(self):
        """Second test."""
        self.assertEqual(self.db_connection, "connected")


if __name__ == '__main__':
    unittest.main()

