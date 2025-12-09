import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class IoBufferedReader {
    public static void main(String[] args) {
        // Using BufferedReader for efficient line-by-line reading
        try {
            BufferedReader reader = new BufferedReader(new FileReader("sample.txt"));
            String line;
            System.out.println("Reading line by line:");
            int lineNumber = 1;
            while ((line = reader.readLine()) != null) {
                System.out.println(lineNumber + ": " + line);
                lineNumber++;
            }
            reader.close();
            System.out.println("\nReading completed!");
        } catch (IOException e) {
            System.out.println("Error reading file: " + e.getMessage());
        }
        
        // Using try-with-resources (automatically closes the reader)
        System.out.println("\nUsing try-with-resources:");
        try (BufferedReader reader = new BufferedReader(new FileReader("sample.txt"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            // Reader is automatically closed here
        } catch (IOException e) {
            System.out.println("Error reading file: " + e.getMessage());
        }
    }
}

