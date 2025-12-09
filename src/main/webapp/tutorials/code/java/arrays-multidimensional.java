public class Main {
    public static void main(String[] args) {
        System.out.println("--- 2D Array (Matrix) Demo ---");

        // 1. Declaration & Initialization
        // A 3x3 matrix (3 rows, 3 columns)
        int[][] matrix = {
                { 1, 2, 3 }, // Row 0
                { 4, 5, 6 }, // Row 1
                { 7, 8, 9 } // Row 2
        };

        // 2. Accessing elements: matrix[rowIndex][colIndex]
        System.out.println("Element at [0][0]: " + matrix[0][0]); // 1
        System.out.println("Element at [1][2]: " + matrix[1][2]); // 6
        System.out.println("Element at [2][1]: " + matrix[2][1]); // 8

        // 3. Iterating through a 2D Array
        System.out.println("\n--- Matrix Print ---");

        for (int i = 0; i < matrix.length; i++) { // Loop through rows
            for (int j = 0; j < matrix[i].length; j++) { // Loop through cols
                System.out.print(matrix[i][j] + " ");
            }
            System.out.println(); // New line after each row
        }

        // 4. Jagged Array (Rows with different lengths)
        System.out.println("\n--- Jagged Array ---");
        int[][] jagged = {
                { 1, 2 },
                { 3, 4, 5, 6 },
                { 7 }
        };

        System.out.println("Row 0 length: " + jagged[0].length);
        System.out.println("Row 1 length: " + jagged[1].length);
    }
}
