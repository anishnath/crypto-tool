import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public class IoBufferedWriter {
    public static void main(String[] args) {
        // Using BufferedWriter for efficient writing
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter("buffered-output.txt"));
            writer.write("Line 1");
            writer.newLine();  // Platform-independent newline
            writer.write("Line 2");
            writer.newLine();
            writer.write("Line 3");
            writer.close();
            System.out.println("File written with BufferedWriter!");
        } catch (IOException e) {
            System.out.println("Error writing file: " + e.getMessage());
        }
        
        // Using try-with-resources for automatic closing
        try (BufferedWriter writer = new BufferedWriter(new FileWriter("buffered-output.txt", true))) {
            writer.write("Appended line 1");
            writer.newLine();
            writer.write("Appended line 2");
            // Writer automatically closed here
            System.out.println("Content appended with try-with-resources!");
        } catch (IOException e) {
            System.out.println("Error writing file: " + e.getMessage());
        }
    }
}

