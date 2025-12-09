public class Identifiers {
    public static void main(String[] args) {
        // Valid identifiers
        int userName = 5;
        int user_name = 10;  // Valid but not conventional
        int $price = 15;     // Valid but not recommended
        int _count = 20;     // Valid but not recommended
        int value2 = 25;     // Numbers OK after first character
        
        // Invalid identifiers (would cause compile errors)
        // int 2value = 5;     // Error: can't start with number
        // int class = 5;      // Error: 'class' is a keyword
        // int void = 10;      // Error: 'void' is a keyword
        
        System.out.println("Valid identifiers work fine!");
        System.out.println("userName: " + userName);
        System.out.println("value2: " + value2);
        
        // Case-sensitive
        int myVar = 1;
        int MyVar = 2;  // Different variable!
        System.out.println("myVar: " + myVar);
        System.out.println("MyVar: " + MyVar);
    }
}

