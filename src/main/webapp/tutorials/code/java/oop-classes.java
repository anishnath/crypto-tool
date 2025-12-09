public class Student {
    // Instance variables
    String name;
    int age;
    
    void displayInfo() {
        System.out.println("Name: " + name);
        System.out.println("Age: " + age);
    }
}

public class OopClasses {
    public static void main(String[] args) {
        // Create objects from the Student class
        Student student1 = new Student();
        student1.name = "Alice";
        student1.age = 20;
        
        Student student2 = new Student();
        student2.name = "Bob";
        student2.age = 22;
        
        // Display information
        System.out.println("Student 1:");
        student1.displayInfo();
        
        System.out.println("\nStudent 2:");
        student2.displayInfo();
    }
}

