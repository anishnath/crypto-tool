# Common Assertions in unittest

import unittest

class TestAssertions(unittest.TestCase):
    """Demonstrating various assertion methods."""
    
    def test_assert_equal(self):
        """Test assertEqual for equality."""
        self.assertEqual(2 + 2, 4)
        self.assertEqual("hello", "hello")
    
    def test_assert_not_equal(self):
        """Test assertNotEqual for inequality."""
        self.assertNotEqual(2 + 2, 5)
        self.assertNotEqual("hello", "world")
    
    def test_assert_true_false(self):
        """Test assertTrue and assertFalse."""
        self.assertTrue(2 > 1)
        self.assertTrue(len([1, 2, 3]) > 0)
        self.assertFalse(2 < 1)
        self.assertFalse(not True)
    
    def test_assert_in(self):
        """Test assertIn for membership."""
        self.assertIn(2, [1, 2, 3])
        self.assertIn("a", "apple")
        self.assertNotIn(5, [1, 2, 3])
    
    def test_assert_is_none(self):
        """Test assertIsNone for None values."""
        value = None
        self.assertIsNone(value)
        self.assertIsNotNone("not none")
    
    def test_assert_is_instance(self):
        """Test assertIsInstance for type checking."""
        self.assertIsInstance([1, 2, 3], list)
        self.assertIsInstance("hello", str)
        self.assertIsInstance(42, int)
    
    def test_assert_almost_equal(self):
        """Test assertAlmostEqual for floating point."""
        # Useful for float comparison (handles rounding errors)
        self.assertAlmostEqual(0.1 + 0.2, 0.3, places=7)
        self.assertAlmostEqual(1/3, 0.333333, places=5)


if __name__ == '__main__':
    unittest.main()

