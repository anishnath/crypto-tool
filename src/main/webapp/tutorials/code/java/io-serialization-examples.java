import java.io.*;

class Person implements Serializable {
    private static final long serialVersionUID = 1L;
    String name;
    int age;
    transient int temporaryField;  // Won't be saved
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
        this.temporaryField = 100;
    }
    
    @Override
    public String toString() {
        return "Person{name='" + name + "', age=" + age + ", temp=" + temporaryField + "}";
    }
}

public class IoSerializationExamples {
    public static void serializePerson(Person person, String filename) {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(filename))) {
            oos.writeObject(person);
            System.out.println("Serialized: " + person);
        } catch (IOException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
    
    public static Person deserializePerson(String filename) {
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(filename))) {
            Person person = (Person) ois.readObject();
            System.out.println("Deserialized: " + person);
            return person;
        } catch (IOException | ClassNotFoundException e) {
            System.out.println("Error: " + e.getMessage());
            return null;
        }
    }
    
    public static void main(String[] args) {
        Person person1 = new Person("Bob", 25);
        
        // Serialize
        serializePerson(person1, "person.ser");
        
        // Deserialize
        Person person2 = deserializePerson("person.ser");
        
        // Note: temporaryField will be 0 (default value) after deserialization
        if (person2 != null) {
            System.out.println("After deserialization, temporaryField is: " + person2.temporaryField);
        }
    }
}

