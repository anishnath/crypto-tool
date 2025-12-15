<?php
// Variadic Functions

// Using ... (splat operator)
function sum(...$numbers)
{
    $total = 0;
    foreach ($numbers as $num) {
        $total += $num;
    }
    return $total;
}

echo sum(1, 2, 3);           // 6
echo "\n";
echo sum(1, 2, 3, 4, 5);     // 15
echo "\n";

// Variadic with regular parameters
function formatList($separator, ...$items)
{
    return implode($separator, $items);
}

echo formatList(", ", "apple", "banana", "cherry");
echo "\n";

// Type-hinted variadic
function sumIntegers(int ...$numbers): int
{
    return array_sum($numbers);
}

echo sumIntegers(10, 20, 30);  // 60
echo "\n";

// Unpacking arrays
$nums = [1, 2, 3, 4, 5];
echo sum(...$nums);  // 15
