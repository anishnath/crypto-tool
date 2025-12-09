import java.util.Objects;

// Class WITHOUT overriding Object methods
class PersonBasic {
    String name;
    int age;

    PersonBasic(String name, int age) {
        this.name = name;
        this.age = age;
    }
}

// Class WITH properly overridden Object methods
class Person {
    String name;
    int age;

    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // Override toString() for meaningful output
    @Override
    public String toString() {
        return "Person{name='" + name + "', age=" + age + "}";
    }

    // Override equals() to compare content
    @Override
    public boolean equals(Object obj) {
        // Same reference check
        if (this == obj) return true;

        // Null and type check
        if (obj == null || getClass() != obj.getClass()) return false;

        // Cast and compare fields
        Person person = (Person) obj;
        return age == person.age && Objects.equals(name, person.name);
    }

    // Override hashCode() - MUST override if equals() is overridden
    @Override
    public int hashCode() {
        return Objects.hash(name, age);
    }
}

// Demonstrating clone() method
class Student implements Cloneable {
    String name;
    int[] scores;  // Reference type to show shallow vs deep copy issue

    Student(String name, int[] scores) {
        this.name = name;
        this.scores = scores;
    }

    // Shallow clone
    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

    // Deep clone method
    protected Student deepClone() throws CloneNotSupportedException {
        Student cloned = (Student) super.clone();
        cloned.scores = scores.clone();  // Clone the array too
        return cloned;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Student{name='").append(name).append("', scores=[");
        for (int i = 0; i < scores.length; i++) {
            sb.append(scores[i]);
            if (i < scores.length - 1) sb.append(", ");
        }
        sb.append("]}");
        return sb.toString();
    }
}

public class ObjectClassDemo {
    public static void main(String[] args) throws CloneNotSupportedException {
        System.out.println("=== toString() Demonstration ===\n");

        PersonBasic basicPerson = new PersonBasic("Alice", 25);
        Person person = new Person("Alice", 25);

        System.out.println("Without override: " + basicPerson);
        System.out.println("With override:    " + person);

        System.out.println("\n=== equals() Demonstration ===\n");

        PersonBasic bp1 = new PersonBasic("Bob", 30);
        PersonBasic bp2 = new PersonBasic("Bob", 30);

        Person p1 = new Person("Bob", 30);
        Person p2 = new Person("Bob", 30);
        Person p3 = p1;  // Same reference

        System.out.println("Basic (no override):");
        System.out.println("bp1 == bp2: " + (bp1 == bp2));           // false
        System.out.println("bp1.equals(bp2): " + bp1.equals(bp2));   // false (default)

        System.out.println("\nWith override:");
        System.out.println("p1 == p2: " + (p1 == p2));               // false
        System.out.println("p1.equals(p2): " + p1.equals(p2));       // true!
        System.out.println("p1 == p3: " + (p1 == p3));               // true
        System.out.println("p1.equals(p3): " + p1.equals(p3));       // true

        System.out.println("\n=== hashCode() Demonstration ===\n");

        System.out.println("p1.hashCode(): " + p1.hashCode());
        System.out.println("p2.hashCode(): " + p2.hashCode());
        System.out.println("Equal objects have same hashCode: " + (p1.hashCode() == p2.hashCode()));

        Person p4 = new Person("Charlie", 35);
        System.out.println("p4.hashCode(): " + p4.hashCode());
        System.out.println("Different objects may have different hashCode");

        System.out.println("\n=== getClass() Demonstration ===\n");

        Object obj = new Person("Dave", 40);

        Class<?> cls = obj.getClass();
        System.out.println("Class name: " + cls.getName());
        System.out.println("Simple name: " + cls.getSimpleName());
        System.out.println("Superclass: " + cls.getSuperclass().getSimpleName());
        System.out.println("Is Person? " + (cls == Person.class));

        System.out.println("\n=== clone() Demonstration ===\n");

        int[] scores = {85, 90, 78};
        Student original = new Student("Emma", scores);

        // Shallow clone
        Student shallowClone = (Student) original.clone();

        // Deep clone
        Student deepClone = original.deepClone();

        System.out.println("Original:     " + original);
        System.out.println("Shallow:      " + shallowClone);
        System.out.println("Deep:         " + deepClone);

        // Modify original's scores
        original.scores[0] = 100;

        System.out.println("\nAfter modifying original.scores[0] = 100:");
        System.out.println("Original:     " + original);
        System.out.println("Shallow:      " + shallowClone);  // Also changed!
        System.out.println("Deep:         " + deepClone);     // Unchanged

        System.out.println("\n=== Key Takeaways ===");
        System.out.println("1. Override toString() for meaningful output");
        System.out.println("2. Override equals() to compare object content");
        System.out.println("3. Always override hashCode() when overriding equals()");
        System.out.println("4. getClass() returns runtime type information");
        System.out.println("5. clone() creates shallow copy by default");
    }
}
