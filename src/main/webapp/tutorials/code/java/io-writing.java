import java.io.FileWriter;
import java.io.IOException;

public class IoWriting {
    public static void main(String[] args) {
        // Writing to a file (overwrites existing content)
        try {
            FileWriter writer = new FileWriter("output.txt");
            writer.write("Hello, World!\n");
            writer.write("This is a test file.\n");
            writer.write("Writing multiple lines.\n");
            writer.close();
            System.out.println("File written successfully!");
        } catch (IOException e) {
            System.out.println("Error writing file: " + e.getMessage());
        }
        
        // Appending to a file
        try {
            FileWriter writer = new FileWriter("output.txt", true);  // true = append mode
            writer.write("This line is appended.\n");
            writer.write("Another appended line.\n");
            writer.close();
            System.out.println("Content appended successfully!");
        } catch (IOException e) {
            System.out.println("Error appending to file: " + e.getMessage());
        }
    }
}

