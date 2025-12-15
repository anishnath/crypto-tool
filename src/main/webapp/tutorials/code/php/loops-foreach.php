<?php
// PHP Foreach Loop Demo
// 8gwifi.org/tutorials

echo "=== Basic Foreach (Values Only) ===\n";
$colors = ["Red", "Green", "Blue", "Yellow"];
foreach ($colors as $color) {
    echo "Color: $color\n";
}

echo "\n=== Foreach with Keys ===\n";
$person = [
    "name" => "John Doe",
    "email" => "john@example.com",
    "age" => 30,
    "city" => "New York"
];

foreach ($person as $key => $value) {
    echo "$key: $value\n";
}

echo "\n=== Foreach with Indexed Array Keys ===\n";
$fruits = ["Apple", "Banana", "Cherry"];
foreach ($fruits as $index => $fruit) {
    echo ($index + 1) . ". $fruit\n";
}

echo "\n=== Foreach with Nested Arrays ===\n";
$users = [
    ["name" => "Alice", "role" => "Admin"],
    ["name" => "Bob", "role" => "Editor"],
    ["name" => "Carol", "role" => "Viewer"]
];

foreach ($users as $user) {
    echo "{$user['name']} ({$user['role']})\n";
}

echo "\n=== Foreach: Building Output ===\n";
$numbers = [1, 2, 3, 4, 5];
$doubled = [];
foreach ($numbers as $num) {
    $doubled[] = $num * 2;
}
echo "Original: " . implode(", ", $numbers) . "\n";
echo "Doubled:  " . implode(", ", $doubled) . "\n";

echo "\n=== Foreach: Counting ===\n";
$scores = [85, 92, 78, 95, 88, 91];
$total = 0;
$count = 0;
foreach ($scores as $score) {
    $total += $score;
    $count++;
}
$average = $total / $count;
echo "Scores: " . implode(", ", $scores) . "\n";
echo "Average: " . number_format($average, 2) . "\n";
?>
