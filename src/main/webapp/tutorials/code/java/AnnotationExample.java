import java.lang.annotation.*;
import java.lang.reflect.*;

// 1. Define valid targets (Method) and retention (Runtime)
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
@interface MyInfo {
    String author();

    String date();

    int version() default 1;
}

class DemoClass {

    // 2. Use the annotation
    @MyInfo(author = "Anish", date = "2023-10-27", version = 2)
    public void printMessage() {
        System.out.println("Hello from DemoClass");
    }

    @Deprecated
    public void oldMethod() {
        System.out.println("This is old.");
    }
}

public class AnnotationExample {
    public static void main(String[] args) throws Exception {

        DemoClass obj = new DemoClass();
        obj.printMessage();

        System.out.println("\n--- Reading Annotations via Reflection ---");
        Method m = obj.getClass().getMethod("printMessage");

        if (m.isAnnotationPresent(MyInfo.class)) {
            MyInfo info = m.getAnnotation(MyInfo.class);
            System.out.println("Author: " + info.author());
            System.out.println("Date: " + info.date());
            System.out.println("Version: " + info.version());
        }
    }
}
