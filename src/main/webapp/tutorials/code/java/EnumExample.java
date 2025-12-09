enum Day {
    SUNDAY("Weekend"),
    MONDAY("Weekday"),
    TUESDAY("Weekday"),
    WEDNESDAY("Weekday"),
    THURSDAY("Weekday"),
    FRIDAY("Weekday"),
    SATURDAY("Weekend");

    private String type;

    // Convert constructor
    Day(String type) {
        this.type = type;
    }

    public String getType() {
        return type;
    }
}

public class EnumExample {
    public static void main(String[] args) {

        Day today = Day.WEDNESDAY;

        // 1. Basic Switch Usage
        switch (today) {
            case SATURDAY:
            case SUNDAY:
                System.out.println("It's the weekend!");
                break;
            default:
                System.out.println("It's a weekday.");
                break;
        }

        // 2. Loop through all values
        System.out.println("\nAll days:");
        for (Day d : Day.values()) {
            System.out.println(d + " is a " + d.getType());
        }
    }
}
