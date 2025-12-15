<?php
// PHP Do-While Loop Demo
// 8gwifi.org/tutorials

echo "=== Basic Do-While Loop ===\n";
$count = 1;
do {
    echo "Count: $count\n";
    $count++;
} while ($count <= 5);

echo "\n=== Do-While: Executes At Least Once ===\n";
$number = 100;

// This won't execute (condition is false from start)
echo "While loop with number = $number:\n";
while ($number < 10) {
    echo "This won't print\n";
    $number++;
}
echo "(Nothing printed - condition was false)\n";

// This WILL execute once (do-while always runs at least once)
$number = 100;
echo "\nDo-while loop with number = $number:\n";
do {
    echo "This prints once! number = $number\n";
    $number++;
} while ($number < 10);

echo "\n=== Do-While: Menu Simulation ===\n";
$choices = [2, 3, 1, 4];  // Simulated user choices
$choiceIndex = 0;

do {
    $choice = $choices[$choiceIndex] ?? 4;

    echo "\n--- Menu ---\n";
    echo "1. View Profile\n";
    echo "2. Edit Settings\n";
    echo "3. Check Messages\n";
    echo "4. Exit\n";
    echo "Choice: $choice\n";

    switch ($choice) {
        case 1:
            echo "→ Displaying profile...\n";
            break;
        case 2:
            echo "→ Opening settings...\n";
            break;
        case 3:
            echo "→ Loading messages...\n";
            break;
        case 4:
            echo "→ Goodbye!\n";
            break;
        default:
            echo "→ Invalid choice!\n";
    }

    $choiceIndex++;
} while ($choice !== 4 && $choiceIndex < count($choices));
?>
