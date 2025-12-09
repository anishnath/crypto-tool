// 1. Define the Custom Exception
class InvalidAgeException extends Exception {
    public InvalidAgeException(String s) {
        // Call constructor of parent Exception
        super(s);
    }
}

public class CustomExceptionExample {

    // 2. Method that throws the custom exception
    static void validate(int age) throws InvalidAgeException {
        if (age < 18) {
            // Throwing our custom exception
            throw new InvalidAgeException("Not valid age to vote");
        } else {
            System.out.println("Welcome to vote");
        }
    }

    public static void main(String args[]) {
        try {
            // 3. Testing with invalid age
            validate(13);
        } catch (InvalidAgeException e) {
            // 4. Catching our custom exception
            System.out.println("Caught Custom Exception:");
            System.out.println("Exception Occurred: " + e);
        }

        System.out.println("Rest of the code...");
    }
}
