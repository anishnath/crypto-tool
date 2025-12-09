public class Main {
    public static void main(String[] args) {
        // 1. Integer types (Whole numbers)
        byte byteVal = 100;
        short shortVal = 10000;
        int intVal = 100000;
        long longVal = 10000000000L; // Note the 'L' suffix

        System.out.println("--- Integer Types ---");
        System.out.println("byte: " + byteVal);
        System.out.println("short: " + shortVal);
        System.out.println("int: " + intVal);
        System.out.println("long: " + longVal);

        // 2. Floating-point types (Decimal numbers)
        float floatVal = 3.14f; // Note the 'f' suffix
        double doubleVal = 3.14159265359;

        System.out.println("\n--- Floating Point Types ---");
        System.out.println("float: " + floatVal);
        System.out.println("double: " + doubleVal);

        // 3. Character type
        char charVal = 'A';
        char unicodeVal = '\u0041'; // Unicode for 'A'

        System.out.println("\n--- Character Type ---");
        System.out.println("char: " + charVal);
        System.out.println("unicode char: " + unicodeVal);

        // 4. Boolean type
        boolean isJavaFun = true;
        boolean isFishTasty = false;

        System.out.println("\n--- Boolean Type ---");
        System.out.println("isJavaFun: " + isJavaFun);
        System.out.println("isFishTasty: " + isFishTasty);
    }
}
