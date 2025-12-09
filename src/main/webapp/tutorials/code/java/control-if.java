public class ControlFlowIf {
    public static void main(String[] args) {
        int score = 85;

        System.out.println("Score: " + score);

        // Simple If-Else
        if (score >= 50) {
            System.out.println("Result: Pass");
        } else {
            System.out.println("Result: Fail");
        }

        // Else-If Ladder (Grading System)
        char grade;
        if (score >= 90) {
            grade = 'A';
        } else if (score >= 80) {
            grade = 'B';
        } else if (score >= 70) {
            grade = 'C';
        } else if (score >= 60) {
            grade = 'D';
        } else {
            grade = 'F';
        }
        System.out.println("Grade: " + grade);

        // Nested If
        boolean hasLicense = true;
        boolean hasCar = false;

        if (hasLicense) {
            if (hasCar) {
                System.out.println("You can drive your car.");
            } else {
                System.out.println("You need to rent a car.");
            }
        } else {
            System.out.println("You need a license used.");
        }
    }
}
