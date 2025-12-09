public class VariableScope {
    public static void main(String[] args) {

        // METHOD SCOPE: 'x' available everywhere in main
        int x = 100;
        System.out.println("Value of x: " + x);

        // BLOCK SCOPE
        {
            int y = 50;
            System.out.println("Value of y (inside block): " + y);
            System.out.println("Value of x (inside block): " + x); // x is visible here
        }

        // System.out.println(y); // ERROR: y is not visible here

        // LOOP SCOPE
        for (int i = 0; i < 3; i++) {
            System.out.println("Loop i: " + i);
        }

        // System.out.println(i); // ERROR: i is not visible here

        // IF BLOCK SCOPE
        if (x > 0) {
            String message = "Positive";
            System.out.println(message);
        }
        // System.out.println(message); // ERROR
    }
}
