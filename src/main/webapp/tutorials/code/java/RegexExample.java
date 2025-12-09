import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexExample {
    public static void main(String[] args) {
        // Example 1: Basic matching
        String text = "The quick brown fox jumps over the lazy dog";
        String patternStr = "quick.*fox";

        Pattern pattern = Pattern.compile(patternStr);
        Matcher matcher = pattern.matcher(text);

        System.out.println("=== Basic Matching ===");
        System.out.println("Text: " + text);
        System.out.println("Pattern: " + patternStr);
        System.out.println("Contains match: " + matcher.find());

        // Example 2: Finding all matches
        System.out.println("\n=== Finding All Matches ===");
        String emailText = "Contact us at support@example.com or sales@company.org";
        Pattern emailPattern = Pattern.compile("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}");
        Matcher emailMatcher = emailPattern.matcher(emailText);

        System.out.println("Text: " + emailText);
        System.out.println("Emails found:");
        while (emailMatcher.find()) {
            System.out.println("  - " + emailMatcher.group());
        }

        // Example 3: Using groups
        System.out.println("\n=== Using Groups ===");
        String dateText = "Today is 2024-12-25 and tomorrow is 2024-12-26";
        Pattern datePattern = Pattern.compile("(\\d{4})-(\\d{2})-(\\d{2})");
        Matcher dateMatcher = datePattern.matcher(dateText);

        while (dateMatcher.find()) {
            System.out.println("Full match: " + dateMatcher.group(0));
            System.out.println("  Year: " + dateMatcher.group(1));
            System.out.println("  Month: " + dateMatcher.group(2));
            System.out.println("  Day: " + dateMatcher.group(3));
        }

        // Example 4: String methods with regex
        System.out.println("\n=== String Methods with Regex ===");
        String phone = "123-456-7890";
        System.out.println("Original: " + phone);
        System.out.println("matches(\"\\\\d{3}-\\\\d{3}-\\\\d{4}\"): " +
            phone.matches("\\d{3}-\\d{3}-\\d{4}"));
        System.out.println("replaceAll(\"-\", \".\"): " + phone.replaceAll("-", "."));

        String csv = "apple,banana,,cherry,,,date";
        System.out.println("\nCSV: " + csv);
        String[] parts = csv.split(",+");  // Split on one or more commas
        System.out.println("Split on ',+': ");
        for (String part : parts) {
            System.out.println("  - " + part);
        }

        // Example 5: Common patterns
        System.out.println("\n=== Validation Examples ===");

        // Validate email
        String email = "user@example.com";
        boolean validEmail = email.matches("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}");
        System.out.println("Email '" + email + "' valid: " + validEmail);

        // Validate phone number
        String phoneNum = "(555) 123-4567";
        boolean validPhone = phoneNum.matches("\\(?\\d{3}\\)?[-.\\s]?\\d{3}[-.\\s]?\\d{4}");
        System.out.println("Phone '" + phoneNum + "' valid: " + validPhone);

        // Validate IP address (simple)
        String ip = "192.168.1.1";
        boolean validIP = ip.matches("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}");
        System.out.println("IP '" + ip + "' valid: " + validIP);

        // Example 6: Case-insensitive matching
        System.out.println("\n=== Case-Insensitive Matching ===");
        Pattern caseInsensitive = Pattern.compile("java", Pattern.CASE_INSENSITIVE);
        String[] texts = {"Java", "JAVA", "java", "JaVa"};
        for (String t : texts) {
            Matcher m = caseInsensitive.matcher(t);
            System.out.println("'" + t + "' matches: " + m.matches());
        }
    }
}
