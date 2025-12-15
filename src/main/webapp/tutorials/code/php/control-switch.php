<?php
// PHP Switch Statement Demo
// 8gwifi.org/tutorials

$dayOfWeek = 3;  // 1=Monday, 7=Sunday

echo "=== Basic Switch Statement ===\n";
switch ($dayOfWeek) {
    case 1:
        echo "Monday - Start of the work week!\n";
        break;
    case 2:
        echo "Tuesday - Keep going!\n";
        break;
    case 3:
        echo "Wednesday - Halfway there!\n";
        break;
    case 4:
        echo "Thursday - Almost Friday!\n";
        break;
    case 5:
        echo "Friday - Weekend is near!\n";
        break;
    case 6:
    case 7:
        echo "Weekend - Time to relax!\n";
        break;
    default:
        echo "Invalid day number.\n";
}

echo "\n=== Switch with Strings ===\n";
$command = "save";

switch ($command) {
    case "new":
        echo "Creating new document...\n";
        break;
    case "open":
        echo "Opening document...\n";
        break;
    case "save":
        echo "Saving document...\n";
        break;
    case "close":
        echo "Closing document...\n";
        break;
    default:
        echo "Unknown command: $command\n";
}

echo "\n=== Fall-through Behavior ===\n";
$grade = "B";

switch ($grade) {
    case "A":
    case "B":
        echo "Great job! You passed with distinction.\n";
        break;
    case "C":
        echo "Good work! You passed.\n";
        break;
    case "D":
        echo "You passed, but consider studying more.\n";
        break;
    case "F":
        echo "Sorry, you need to retake the course.\n";
        break;
}
?>
