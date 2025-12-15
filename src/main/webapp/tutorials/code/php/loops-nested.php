<?php
// PHP Nested For Loops Demo
// 8gwifi.org/tutorials

echo "=== Multiplication Table (1-5) ===\n";
echo "    ";
for ($i = 1; $i <= 5; $i++) {
    printf("%4d", $i);
}
echo "\n    " . str_repeat("----", 5) . "\n";

for ($i = 1; $i <= 5; $i++) {
    printf("%2d |", $i);
    for ($j = 1; $j <= 5; $j++) {
        printf("%4d", $i * $j);
    }
    echo "\n";
}

echo "\n=== Right Triangle Pattern ===\n";
$rows = 5;
for ($i = 1; $i <= $rows; $i++) {
    for ($j = 1; $j <= $i; $j++) {
        echo "* ";
    }
    echo "\n";
}

echo "\n=== Number Pyramid ===\n";
for ($i = 1; $i <= 5; $i++) {
    // Print leading spaces
    for ($space = 5 - $i; $space > 0; $space--) {
        echo " ";
    }
    // Print numbers
    for ($j = 1; $j <= $i; $j++) {
        echo "$j ";
    }
    echo "\n";
}

echo "\n=== 2D Array Processing ===\n";
$matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];

$sum = 0;
for ($row = 0; $row < count($matrix); $row++) {
    for ($col = 0; $col < count($matrix[$row]); $col++) {
        echo $matrix[$row][$col] . " ";
        $sum += $matrix[$row][$col];
    }
    echo "\n";
}
echo "Sum of all elements: $sum\n";

echo "\n=== Finding Pairs ===\n";
$numbers = [2, 4, 6, 8];
$target = 10;

echo "Pairs that sum to $target:\n";
for ($i = 0; $i < count($numbers); $i++) {
    for ($j = $i + 1; $j < count($numbers); $j++) {
        if ($numbers[$i] + $numbers[$j] === $target) {
            echo "  {$numbers[$i]} + {$numbers[$j]} = $target\n";
        }
    }
}
?>
