// Public class - accessible from anywhere
public class Student {
    // Public - accessible from anywhere
    public String name;
    
    // Private - only accessible within this class
    private int age;
    private double gpa;
    
    // Default (package-private) - accessible within same package
    String studentId;
    
    // Public constructor
    public Student(String name, int age, String studentId) {
        this.name = name;
        this.age = age;
        this.studentId = studentId;
        this.gpa = 0.0;
    }
    
    // Public getter for private variable
    public int getAge() {
        return age;
    }
    
    // Public setter for private variable
    public void setAge(int age) {
        if (age > 0 && age < 150) {
            this.age = age;
        }
    }
    
    // Public getter for GPA
    public double getGpa() {
        return gpa;
    }
    
    // Public setter for GPA with validation
    public void setGpa(double gpa) {
        if (gpa >= 0.0 && gpa <= 4.0) {
            this.gpa = gpa;
        }
    }
    
    // Public method
    public void displayInfo() {
        System.out.println("Name: " + name);
        System.out.println("Age: " + age);
        System.out.println("Student ID: " + studentId);
        System.out.println("GPA: " + gpa);
    }
}

public class OopAccessModifiers {
    public static void main(String[] args) {
        Student student = new Student("Alice", 20, "STU001");
        
        // Access public variable directly
        System.out.println("Name: " + student.name);
        
        // Cannot access private variables directly
        // System.out.println(student.age);  // Error!
        
        // Use public getter methods instead
        System.out.println("Age: " + student.getAge());
        
        // Use public setter methods
        student.setAge(21);
        student.setGpa(3.5);
        
        student.displayInfo();
    }
}

