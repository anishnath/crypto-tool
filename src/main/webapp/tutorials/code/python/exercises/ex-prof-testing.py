import unittest

def multiply(x, y):
    return x * y

class TestMath(unittest.TestCase):
    
    def test_multiply(self):
        # Write a test case to verify that 3 * 4 equals 12
        pass
        
    def test_multiply_negative(self):
        # Write a test case to verify that -2 * 3 equals -6
        pass

if __name__ == '__main__':
    unittest.main()
