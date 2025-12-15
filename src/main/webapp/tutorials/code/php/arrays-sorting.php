<?php
// PHP Array Sorting - Basic Examples
// 8gwifi.org/tutorials

echo "=== Basic sort() and rsort() ===\n";

$numbers = [3, 1, 4, 1, 5, 9, 2, 6];
echo "Original: " . implode(", ", $numbers) . "\n";

sort($numbers);
echo "sort(): " . implode(", ", $numbers) . "\n";

$letters = ["c", "a", "b", "d"];
rsort($letters);
echo "rsort(): " . implode(", ", $letters) . "\n";

echo "\n=== Sorting Flags ===\n";

// Problem with default sort on version strings
$versions = ["img1", "img10", "img2", "img21", "img3"];
sort($versions);
echo "Regular sort: " . implode(", ", $versions) . "\n";

$versions = ["img1", "img10", "img2", "img21", "img3"];
sort($versions, SORT_NATURAL);
echo "Natural sort: " . implode(", ", $versions) . "\n";

// Case-insensitive sort
$names = ["alice", "Bob", "CAROL", "david"];
sort($names, SORT_STRING | SORT_FLAG_CASE);
echo "Case-insensitive: " . implode(", ", $names) . "\n";

echo "\n=== Associative Array Sorting ===\n";

$scores = [
    "Alice" => 85,
    "Bob" => 92,
    "Carol" => 78,
    "David" => 95
];
echo "Original scores:\n";
print_r($scores);

// Sort by value, preserve keys
asort($scores);
echo "asort() - by value ascending:\n";
foreach ($scores as $name => $score) {
    echo "  $name: $score\n";
}

// Sort by value descending
arsort($scores);
echo "\narsort() - by value descending:\n";
foreach ($scores as $name => $score) {
    echo "  $name: $score\n";
}

// Sort by key
ksort($scores);
echo "\nksort() - by key ascending:\n";
foreach ($scores as $name => $score) {
    echo "  $name: $score\n";
}

echo "\n=== shuffle() - Randomize ===\n";

$cards = ["Ace", "King", "Queen", "Jack", "10"];
echo "Before shuffle: " . implode(", ", $cards) . "\n";
shuffle($cards);
echo "After shuffle: " . implode(", ", $cards) . "\n";

echo "\n=== array_reverse() ===\n";

$sequence = [1, 2, 3, 4, 5];
$reversed = array_reverse($sequence);
echo "Original: " . implode(", ", $sequence) . "\n";
echo "Reversed: " . implode(", ", $reversed) . "\n";
?>
