// Package declaration - must be first non-comment line
package com.example.util;

// Import statements
import java.util.ArrayList;
import java.util.List;
import static java.lang.Math.PI;  // Static import

public class PackageDemo {
    public static void main(String[] args) {
        // Using imported classes
        List<String> names = new ArrayList<>();
        names.add("Alice");
        names.add("Bob");
        
        System.out.println("Names: " + names);
        System.out.println("PI value: " + PI);
        
        // Using fully qualified name (no import needed)
        java.util.Date date = new java.util.Date();
        System.out.println("Current date: " + date);
    }
}

// Another class in the same package
class Helper {
    public static void display(String message) {
        System.out.println("Helper: " + message);
    }
}

