<?php
// PHP While Loop Demo
// 8gwifi.org/tutorials

echo "=== Basic While Loop ===\n";
$count = 1;
while ($count <= 5) {
    echo "Count: $count\n";
    $count++;
}

echo "\n=== While Loop with Array ===\n";
$fruits = ["Apple", "Banana", "Cherry", "Date"];
$index = 0;
while ($index < count($fruits)) {
    echo ($index + 1) . ". " . $fruits[$index] . "\n";
    $index++;
}

echo "\n=== While Loop: Sum Until Threshold ===\n";
$sum = 0;
$number = 1;
while ($sum < 50) {
    $sum += $number;
    echo "Added $number, Sum = $sum\n";
    $number++;
}
echo "Final sum: $sum\n";

echo "\n=== While Loop: User Input Simulation ===\n";
$attempts = 0;
$maxAttempts = 3;
$correctPassword = "secret";
$passwords = ["wrong", "incorrect", "secret"];  // Simulated inputs

while ($attempts < $maxAttempts) {
    $input = $passwords[$attempts];
    echo "Attempt " . ($attempts + 1) . ": Trying '$input'... ";

    if ($input === $correctPassword) {
        echo "Access granted!\n";
        break;
    }
    echo "Access denied.\n";
    $attempts++;
}

if ($attempts >= $maxAttempts && $passwords[$attempts-1] !== $correctPassword) {
    echo "Account locked after $maxAttempts attempts.\n";
}
?>
