// Example of a class that could be packaged into a JAR
package com.example.library;

public class Calculator {
    public static int add(int a, int b) {
        return a + b;
    }
    
    public static int multiply(int a, int b) {
        return a * b;
    }
    
    public static double divide(double a, double b) {
        if (b == 0) {
            throw new IllegalArgumentException("Cannot divide by zero");
        }
        return a / b;
    }
}

// To create a JAR file:
// 1. Compile: javac -d . Calculator.java
// 2. Create JAR: jar cvf calculator.jar com/
// 3. Use in another project: add calculator.jar to classpath

