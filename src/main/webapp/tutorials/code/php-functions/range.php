<?php
// Numeric range
$numbers = range(1, 10);
echo "1 to 10: " . implode(", ", $numbers) . "\n";

// Range with step
$evens = range(0, 20, 2);
echo "Even numbers: " . implode(", ", $evens) . "\n";

// Reverse range
$countdown = range(10, 1);
echo "Countdown: " . implode(", ", $countdown) . "\n";

// Letter range
$letters = range('a', 'z');
echo "Alphabet: " . implode(", ", $letters) . "\n";

// Decimal range
$decimals = range(0, 1, 0.1);
echo "Decimals: " . implode(", ", array_map(fn($n) => number_format($n, 1), $decimals));
?>