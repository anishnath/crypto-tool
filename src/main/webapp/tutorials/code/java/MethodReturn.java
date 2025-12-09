public class MethodReturn {

    // Method returning an integer
    static int square(int x) {
        return x * x;
    }

    // Method returning a String
    static String getGrade(int score) {
        if (score >= 90) {
            return "A";
        } else if (score >= 80) {
            return "B";
        } else {
            return "C";
        }
    }

    // Method returning boolean
    static boolean isAdult(int age) {
        return age >= 18;
    }

    public static void main(String[] args) {
        // 1. Store result in variable
        int num = 5;
        int sq = square(num);
        System.out.println("Square of " + num + " is " + sq);

        // 2. Use directly in check
        int myAge = 16;
        if (isAdult(myAge)) {
            System.out.println("Adult access granted.");
        } else {
            System.out.println("Underage access denied.");
        }

        // 3. Print directly
        System.out.println("Your grade is: " + getGrade(85));
    }
}
