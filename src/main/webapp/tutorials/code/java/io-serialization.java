import java.io.*;

// Class must implement Serializable interface
class Student implements Serializable {
    private static final long serialVersionUID = 1L;
    String name;
    int age;
    transient String password;  // transient fields are not serialized
    
    public Student(String name, int age, String password) {
        this.name = name;
        this.age = age;
        this.password = password;
    }
    
    @Override
    public String toString() {
        return "Student{name='" + name + "', age=" + age + ", password='" + password + "'}";
    }
}

public class IoSerialization {
    public static void main(String[] args) {
        // Serialization - writing object to file
        Student student = new Student("Alice", 20, "secret123");
        
        try {
            FileOutputStream fileOut = new FileOutputStream("student.ser");
            ObjectOutputStream out = new ObjectOutputStream(fileOut);
            out.writeObject(student);
            out.close();
            fileOut.close();
            System.out.println("Object serialized successfully!");
            System.out.println("Original: " + student);
        } catch (IOException e) {
            System.out.println("Error serializing: " + e.getMessage());
        }
        
        // Deserialization - reading object from file
        try {
            FileInputStream fileIn = new FileInputStream("student.ser");
            ObjectInputStream in = new ObjectInputStream(fileIn);
            Student deserializedStudent = (Student) in.readObject();
            in.close();
            fileIn.close();
            System.out.println("\nObject deserialized successfully!");
            System.out.println("Deserialized: " + deserializedStudent);
            System.out.println("Note: password is null (transient field)");
        } catch (IOException | ClassNotFoundException e) {
            System.out.println("Error deserializing: " + e.getMessage());
        }
    }
}

