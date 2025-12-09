public class Student {
    String name;
    int age;
    
    // Default constructor
    public Student() {
        name = "Unknown";
        age = 0;
        System.out.println("Default constructor called");
    }
    
    // Parameterized constructor
    public Student(String name, int age) {
        this.name = name;
        this.age = age;
        System.out.println("Parameterized constructor called");
    }
    
    void displayInfo() {
        System.out.println("Name: " + name + ", Age: " + age);
    }
}

public class OopConstructors {
    public static void main(String[] args) {
        // Using default constructor
        Student student1 = new Student();
        System.out.println("Student 1:");
        student1.displayInfo();
        
        System.out.println();
        
        // Using parameterized constructor
        Student student2 = new Student("Alice", 20);
        System.out.println("Student 2:");
        student2.displayInfo();
        
        Student student3 = new Student("Bob", 22);
        System.out.println("Student 3:");
        student3.displayInfo();
    }
}

