public class SwitchStatement {
    public static void main(String[] args) {
        int day = 3;
        String dayName;

        // Traditional Switch
        // 1=Mon, 2=Tue, 3=Wed, etc.
        switch (day) {
            case 1:
                dayName = "Monday";
                break;
            case 2:
                dayName = "Tuesday";
                break;
            case 3:
                dayName = "Wednesday";
                break;
            case 4:
                dayName = "Thursday";
                break;
            case 5:
                dayName = "Friday";
                break;
            case 6:
                dayName = "Saturday";
                break;
            case 7:
                dayName = "Sunday";
                break;
            default:
                dayName = "Invalid Day";
                break;
        }
        System.out.println("Day " + day + " is " + dayName);

        // Fall-Through Logic Example
        // No break means it continues executing!
        System.out.println("\n--- Fall-Through Demo ---");
        char grade = 'B';
        switch (grade) {
            case 'A':
            case 'B':
            case 'C':
                System.out.println("Pass");
                break;
            case 'D':
            case 'F':
                System.out.println("Fail");
                break;
            default:
                System.out.println("Invalid Grade");
        }

        // Modern Switch (Java 14+) - Commented out for compatibility if using old JDK
        /*
         * String type = switch (day) {
         * case 1, 2, 3, 4, 5 -> "Weekday";
         * case 6, 7 -> "Weekend";
         * default -> "Unknown";
         * };
         * System.out.println("It is a " + type);
         */
    }
}
