<?php
// PHP For Loop Demo
// 8gwifi.org/tutorials

echo "=== Basic For Loop ===\n";
for ($i = 1; $i <= 5; $i++) {
    echo "Iteration: $i\n";
}

echo "\n=== For Loop: Counting Down ===\n";
for ($i = 5; $i >= 1; $i--) {
    echo "$i... ";
}
echo "Liftoff!\n";

echo "\n=== For Loop: Step Value ===\n";
echo "Even numbers 2-10: ";
for ($i = 2; $i <= 10; $i += 2) {
    echo "$i ";
}
echo "\n";

echo "\nMultiples of 5 (0-50): ";
for ($i = 0; $i <= 50; $i += 5) {
    echo "$i ";
}
echo "\n";

echo "\n=== For Loop: Array Iteration ===\n";
$colors = ["Red", "Green", "Blue", "Yellow"];
$length = count($colors);

for ($i = 0; $i < $length; $i++) {
    echo ($i + 1) . ". " . $colors[$i] . "\n";
}

echo "\n=== For Loop: Multiple Expressions ===\n";
// Multiple initializations and updates
for ($i = 0, $j = 10; $i < $j; $i++, $j--) {
    echo "i = $i, j = $j\n";
}

echo "\n=== For Loop: Building a String ===\n";
$stars = "";
for ($i = 1; $i <= 5; $i++) {
    $stars .= "*";
    echo "Level $i: $stars\n";
}
?>
