<?php
// PHP If Statements Demo
// 8gwifi.org/tutorials

$age = 25;
$hasLicense = true;

echo "=== Basic If Statement ===\n";
if ($age >= 18) {
    echo "You are an adult.\n";
}

echo "\n=== If-Else Statement ===\n";
$temperature = 35;
if ($temperature > 30) {
    echo "It's hot outside! Temperature: {$temperature}°C\n";
} else {
    echo "The weather is nice. Temperature: {$temperature}°C\n";
}

echo "\n=== If-Elseif-Else Statement ===\n";
$score = 85;
if ($score >= 90) {
    $grade = 'A';
} elseif ($score >= 80) {
    $grade = 'B';
} elseif ($score >= 70) {
    $grade = 'C';
} elseif ($score >= 60) {
    $grade = 'D';
} else {
    $grade = 'F';
}
echo "Score: $score → Grade: $grade\n";

echo "\n=== Multiple Conditions ===\n";
if ($age >= 18 && $hasLicense) {
    echo "You can drive a car.\n";
} else {
    echo "You cannot drive yet.\n";
}

echo "\n=== Nested If ===\n";
$isWeekend = true;
$isRaining = false;

if ($isWeekend) {
    if ($isRaining) {
        echo "Stay home and watch movies.\n";
    } else {
        echo "Go to the park!\n";
    }
} else {
    echo "It's a workday.\n";
}
?>
