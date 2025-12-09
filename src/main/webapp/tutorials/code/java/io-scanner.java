import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

public class IoScanner {
    public static void main(String[] args) {
        // Reading from a file using Scanner
        try {
            Scanner scanner = new Scanner(new File("sample.txt"));
            System.out.println("Reading file with Scanner:");
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                System.out.println(line);
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            System.out.println("File not found: " + e.getMessage());
        }
        
        // Reading different data types
        try {
            Scanner scanner = new Scanner(new File("data.txt"));
            System.out.println("\nReading different types:");
            while (scanner.hasNext()) {
                if (scanner.hasNextInt()) {
                    int number = scanner.nextInt();
                    System.out.println("Integer: " + number);
                } else if (scanner.hasNextDouble()) {
                    double decimal = scanner.nextDouble();
                    System.out.println("Double: " + decimal);
                } else {
                    String text = scanner.next();
                    System.out.println("String: " + text);
                }
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            System.out.println("File not found: " + e.getMessage());
        }
    }
}

