import java.lang.reflect.*;

class SecretClass {
    public String publicInfo = "I am public";
    private String secret = "I am PRIVATE stuff!";

    private void spyMethod() {
        System.out.println("Spy method executed!");
    }
}

public class ReflectionExample {
    public static void main(String[] args) {
        try {
            SecretClass obj = new SecretClass();
            Class cls = obj.getClass();

            System.out.println("Class Name: " + cls.getName());

            // 1. Access Public Field
            System.out.println("Public: " + obj.publicInfo);

            // 2. Access Private Field (Hack!)
            Field privateField = cls.getDeclaredField("secret");
            privateField.setAccessible(true); // THE KEY LINE
            System.out.println("Private (Hacked): " + privateField.get(obj));

            // 3. Invoke Private Method
            Method privateMethod = cls.getDeclaredMethod("spyMethod");
            privateMethod.setAccessible(true);
            privateMethod.invoke(obj);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
