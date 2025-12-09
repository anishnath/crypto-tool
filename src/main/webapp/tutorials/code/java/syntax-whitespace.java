public class Whitespace {
    public static void main(String[] args) {
        // These are all equivalent - Java ignores extra whitespace
        int x=5;
        int y = 10;
        int z  =  15;
        
        System.out.println(x+y+z);
        System.out.println(x + y + z);
        
        // But whitespace improves readability!
        if(x>0){
            System.out.println("Positive");
        }
        
        // Much more readable:
        if (x > 0) {
            System.out.println("Positive");
        }
    }
}

