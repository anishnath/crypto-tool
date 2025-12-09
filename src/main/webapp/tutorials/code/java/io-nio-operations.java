import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.io.IOException;
import java.util.List;

public class IoNioOperations {
    public static void main(String[] args) {
        // Copying a file
        try {
            Path source = Paths.get("source.txt");
            Path target = Paths.get("copy.txt");
            Files.copy(source, target, StandardCopyOption.REPLACE_EXISTING);
            System.out.println("File copied successfully!");
        } catch (IOException e) {
            System.out.println("Error copying file: " + e.getMessage());
        }
        
        // Moving/renaming a file
        try {
            Path source = Paths.get("oldname.txt");
            Path target = Paths.get("newname.txt");
            Files.move(source, target, StandardCopyOption.REPLACE_EXISTING);
            System.out.println("File moved successfully!");
        } catch (IOException e) {
            System.out.println("Error moving file: " + e.getMessage());
        }
        
        // Deleting a file
        try {
            Path fileToDelete = Paths.get("delete-me.txt");
            Files.delete(fileToDelete);
            System.out.println("File deleted successfully!");
        } catch (IOException e) {
            System.out.println("Error deleting file: " + e.getMessage());
        }
        
        // Checking if file exists
        Path path = Paths.get("example.txt");
        if (Files.exists(path)) {
            System.out.println("\nFile exists!");
            try {
                System.out.println("Size: " + Files.size(path) + " bytes");
                System.out.println("Is readable: " + Files.isReadable(path));
                System.out.println("Is writable: " + Files.isWritable(path));
            } catch (IOException e) {
                System.out.println("Error getting file attributes");
            }
        } else {
            System.out.println("File does not exist");
        }
        
        // Creating directory
        try {
            Path dir = Paths.get("nio-dir");
            Files.createDirectories(dir);  // Creates parent directories if needed
            System.out.println("Directory created!");
        } catch (IOException e) {
            System.out.println("Error creating directory: " + e.getMessage());
        }
    }
}

