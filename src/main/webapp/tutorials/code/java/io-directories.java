import java.io.File;

public class IoDirectories {
    public static void main(String[] args) {
        // Create a File object for a directory
        File dir = new File("test_directory");
        
        // Check if directory exists
        if (dir.exists()) {
            System.out.println("Directory exists!");
            System.out.println("Is directory: " + dir.isDirectory());
        } else {
            System.out.println("Directory does not exist.");
        }
        
        // Create directory
        boolean created = dir.mkdir();
        if (created) {
            System.out.println("\nDirectory created successfully!");
        } else {
            System.out.println("\nDirectory already exists or cannot be created.");
        }
        
        // Create nested directories
        File nestedDir = new File("parent/child/grandchild");
        boolean createdNested = nestedDir.mkdirs();  // Creates parent directories if needed
        if (createdNested) {
            System.out.println("Nested directories created!");
        }
        
        // List files in current directory
        File currentDir = new File(".");
        System.out.println("\nFiles and directories in current directory:");
        String[] files = currentDir.list();
        if (files != null) {
            for (String fileName : files) {
                File file = new File(currentDir, fileName);
                if (file.isDirectory()) {
                    System.out.println("[DIR] " + fileName);
                } else {
                    System.out.println("[FILE] " + fileName);
                }
            }
        }
        
        // Delete directory (must be empty)
        if (dir.exists() && dir.isDirectory()) {
            // First delete any files inside
            File[] dirFiles = dir.listFiles();
            if (dirFiles != null) {
                for (File f : dirFiles) {
                    f.delete();
                }
            }
            // Then delete the directory
            boolean deleted = dir.delete();
            if (deleted) {
                System.out.println("\nDirectory deleted successfully!");
            }
        }
    }
}

