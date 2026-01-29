<?php
// Shuffle array
$cards = ["A", "K", "Q", "J", "10", "9", "8", "7"];
echo "Original: " . implode(", ", $cards) . "\n";

shuffle($cards);
echo "Shuffled: " . implode(", ", $cards) . "\n";

// Shuffle again
shuffle($cards);
echo "Shuffled again: " . implode(", ", $cards) . "\n";

// Shuffle numbers
$numbers = range(1, 10);
shuffle($numbers);
echo "Random numbers: " . implode(", ", $numbers) . "\n";

// Note: Keys are reset to 0, 1, 2, etc.
$assoc = ["a" => 1, "b" => 2, "c" => 3];
shuffle($assoc);
echo "Shuffled (keys reset): ";
print_r($assoc);
?>