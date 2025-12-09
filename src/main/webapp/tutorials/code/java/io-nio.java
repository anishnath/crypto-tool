import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.io.IOException;
import java.util.List;

public class IoNio {
    public static void main(String[] args) {
        // Creating a Path object
        Path path = Paths.get("example.txt");
        System.out.println("Path: " + path);
        System.out.println("Absolute path: " + path.toAbsolutePath());
        System.out.println("File name: " + path.getFileName());
        System.out.println("Parent: " + path.getParent());
        
        // Reading all lines from a file
        try {
            List<String> lines = Files.readAllLines(path);
            System.out.println("\nFile contents:");
            for (String line : lines) {
                System.out.println(line);
            }
        } catch (IOException e) {
            System.out.println("Error reading file: " + e.getMessage());
        }
        
        // Writing all lines to a file
        try {
            List<String> content = List.of("Line 1", "Line 2", "Line 3");
            Path outputPath = Paths.get("nio-output.txt");
            Files.write(outputPath, content);
            System.out.println("\nFile written successfully!");
        } catch (IOException e) {
            System.out.println("Error writing file: " + e.getMessage());
        }
    }
}

