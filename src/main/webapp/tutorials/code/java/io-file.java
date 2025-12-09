import java.io.File;

public class IoFile {
    public static void main(String[] args) {
        // Create a File object (doesn't create actual file)
        File file = new File("example.txt");
        
        // Check if file exists
        if (file.exists()) {
            System.out.println("File exists!");
            System.out.println("File name: " + file.getName());
            System.out.println("Absolute path: " + file.getAbsolutePath());
            System.out.println("File size: " + file.length() + " bytes");
            System.out.println("Is file: " + file.isFile());
            System.out.println("Is directory: " + file.isDirectory());
            System.out.println("Can read: " + file.canRead());
            System.out.println("Can write: " + file.canWrite());
        } else {
            System.out.println("File does not exist.");
        }
        
        // Create a new file
        try {
            boolean created = file.createNewFile();
            if (created) {
                System.out.println("\nFile created successfully!");
            } else {
                System.out.println("\nFile already exists or cannot be created.");
            }
        } catch (Exception e) {
            System.out.println("Error creating file: " + e.getMessage());
        }
        
        // Get file information after creation
        if (file.exists()) {
            System.out.println("\nAfter creation:");
            System.out.println("File name: " + file.getName());
            System.out.println("File size: " + file.length() + " bytes");
        }
    }
}

