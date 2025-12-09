public class Main {
    public static void main(String[] args) {
        String text = "Java Programming";

        System.out.println("Original Text: " + text);

        // 1. Length
        System.out.println("Length: " + text.length());

        // 2. Changing Case
        System.out.println("To Uppercase: " + text.toUpperCase());
        System.out.println("To Lowercase: " + text.toLowerCase());

        // 3. Finding Characters
        System.out.println("Char at index 5: " + text.charAt(5)); // 'P'
        System.out.println("Index of 'Programming': " + text.indexOf("Programming"));

        // 4. Substrings
        System.out.println("Substring (0-4): " + text.substring(0, 4)); // "Java"

        // 5. Replacement
        String newText = text.replace("Java", "Python");
        System.out.println("Replaced: " + newText);

        // 6. Checking content
        System.out.println("Contains 'Java': " + text.contains("Java"));
        System.out.println("Starts with 'Java': " + text.startsWith("Java"));
        System.out.println("Ends with 'World': " + text.endsWith("World"));

        // 7. Trimming
        String dirtyText = "   Clean Me   ";
        System.out.println("Trimmed: '" + dirtyText.trim() + "'");
    }
}
