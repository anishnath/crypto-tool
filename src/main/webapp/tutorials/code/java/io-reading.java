import java.io.FileReader;
import java.io.IOException;

public class IoReading {
    public static void main(String[] args) {
        // Reading character by character
        try {
            FileReader reader = new FileReader("sample.txt");
            int character;
            System.out.println("Reading character by character:");
            while ((character = reader.read()) != -1) {
                System.out.print((char) character);
            }
            reader.close();
            System.out.println("\n\nReading completed!");
        } catch (IOException e) {
            System.out.println("Error reading file: " + e.getMessage());
        }
        
        // Reading into a character array
        try {
            FileReader reader = new FileReader("sample.txt");
            char[] buffer = new char[1024];
            int charactersRead;
            System.out.println("\nReading into buffer:");
            while ((charactersRead = reader.read(buffer)) != -1) {
                System.out.print(new String(buffer, 0, charactersRead));
            }
            reader.close();
        } catch (IOException e) {
            System.out.println("Error reading file: " + e.getMessage());
        }
    }
}

