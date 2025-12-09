import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

public class IoScannerParsing {
    public static void main(String[] args) {
        // Using different Scanner methods
        try {
            Scanner scanner = new Scanner(new File("input.txt"));
            
            // next() - reads next token (word)
            System.out.println("Reading tokens with next():");
            while (scanner.hasNext()) {
                String token = scanner.next();
                System.out.print(token + " ");
            }
            System.out.println("\n");
            
            scanner.close();
        } catch (FileNotFoundException e) {
            System.out.println("File not found");
        }
        
        // Using custom delimiter
        try {
            Scanner scanner = new Scanner(new File("delimited.txt"));
            scanner.useDelimiter(",");  // Use comma as delimiter
            
            System.out.println("Reading with comma delimiter:");
            while (scanner.hasNext()) {
                String item = scanner.next().trim();
                System.out.println("- " + item);
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            System.out.println("File not found");
        }
        
        // Reading specific types
        try {
            Scanner scanner = new Scanner(new File("numbers.txt"));
            System.out.println("\nReading numbers:");
            while (scanner.hasNextInt()) {
                int num = scanner.nextInt();
                System.out.println("Number: " + num);
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            System.out.println("File not found");
        }
    }
}

