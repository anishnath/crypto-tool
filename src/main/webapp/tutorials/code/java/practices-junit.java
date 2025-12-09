import org.junit.Test;
import org.junit.Before;
import org.junit.After;
import static org.junit.Assert.*;

public class CalculatorTest {
    private Calculator calculator;
    
    @Before
    public void setUp() {
        calculator = new Calculator();
        System.out.println("Setting up test");
    }
    
    @After
    public void tearDown() {
        calculator = null;
        System.out.println("Cleaning up test");
    }
    
    @Test
    public void testAdd() {
        int result = calculator.add(5, 3);
        assertEquals(8, result);
    }
    
    @Test
    public void testMultiply() {
        int result = calculator.multiply(4, 7);
        assertEquals(28, result);
    }
    
    @Test
    public void testAddNegativeNumbers() {
        int result = calculator.add(-5, -3);
        assertEquals(-8, result);
    }
}

class Calculator {
    public int add(int a, int b) {
        return a + b;
    }
    
    public int multiply(int a, int b) {
        return a * b;
    }
}

