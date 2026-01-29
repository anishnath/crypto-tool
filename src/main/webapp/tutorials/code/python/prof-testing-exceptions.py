# Testing Exceptions with assertRaises

import unittest

def divide(x, y):
    """Divide x by y, raise ValueError if y is zero."""
    if y == 0:
        raise ValueError("Cannot divide by zero")
    return x / y

def get_item(items, index):
    """Get item at index, raise IndexError if out of range."""
    if index < 0 or index >= len(items):
        raise IndexError("Index out of range")
    return items[index]


class TestExceptions(unittest.TestCase):
    """Testing that functions raise expected exceptions."""
    
    def test_divide_by_zero_raises_error(self):
        """Test that dividing by zero raises ValueError."""
        with self.assertRaises(ValueError):
            divide(10, 0)
    
    def test_divide_by_zero_message(self):
        """Test exception message."""
        with self.assertRaises(ValueError) as context:
            divide(10, 0)
        
        self.assertIn("Cannot divide by zero", str(context.exception))
    
    def test_divide_normal_no_error(self):
        """Test that normal division doesn't raise error."""
        # This should NOT raise an exception
        result = divide(10, 2)
        self.assertEqual(result, 5.0)
    
    def test_index_error(self):
        """Test that invalid index raises IndexError."""
        items = [1, 2, 3]
        with self.assertRaises(IndexError):
            get_item(items, 5)  # Index out of range
    
    def test_index_error_negative(self):
        """Test negative index raises IndexError."""
        items = [1, 2, 3]
        with self.assertRaises(IndexError):
            get_item(items, -1)  # Negative index not allowed


if __name__ == '__main__':
    unittest.main()





