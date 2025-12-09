// A simple Generic Class
class Box<T> {
    private T t;

    public void set(T t) {
        this.t = t;
    }

    public T get() {
        return t;
    }
}

public class GenericsExample {
    public static void main(String[] args) {
        // 1. Box for Integers
        Box<Integer> integerBox = new Box<Integer>();
        integerBox.set(100);

        // No casting needed
        Integer i = integerBox.get();
        System.out.println("Integer Value: " + i);

        // 2. Box for Strings
        Box<String> stringBox = new Box<String>();
        stringBox.set("Hello Generics");

        System.out.println("String Value: " + stringBox.get());

        // 3. Type Safety
        // integerBox.set("String"); // This would cause a compile error!
    }
}
