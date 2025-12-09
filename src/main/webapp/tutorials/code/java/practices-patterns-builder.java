// Builder Pattern - constructs complex objects step by step
class Person {
    private String name;
    private int age;
    private String email;
    private String address;
    
    private Person(Builder builder) {
        this.name = builder.name;
        this.age = builder.age;
        this.email = builder.email;
        this.address = builder.address;
    }
    
    public static class Builder {
        private String name;
        private int age;
        private String email;
        private String address;
        
        public Builder name(String name) {
            this.name = name;
            return this;
        }
        
        public Builder age(int age) {
            this.age = age;
            return this;
        }
        
        public Builder email(String email) {
            this.email = email;
            return this;
        }
        
        public Builder address(String address) {
            this.address = address;
            return this;
        }
        
        public Person build() {
            return new Person(this);
        }
    }
    
    @Override
    public String toString() {
        return "Person{name='" + name + "', age=" + age + ", email='" + email + "', address='" + address + "'}";
    }
}

// Usage
public class BuilderDemo {
    public static void main(String[] args) {
        Person person = new Person.Builder()
            .name("Alice")
            .age(30)
            .email("alice@example.com")
            .address("123 Main St")
            .build();
        
        System.out.println(person);
    }
}

