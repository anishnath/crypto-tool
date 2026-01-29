<?php
// Split into chunks of 2
$numbers = [1, 2, 3, 4, 5, 6, 7, 8];
echo "Original: ";
print_r($numbers);

$chunks = array_chunk($numbers, 2);
echo "\nChunks of 2: ";
print_r($chunks);

// Chunks of 3
$chunks3 = array_chunk($numbers, 3);
echo "\nChunks of 3: ";
print_r($chunks3);

// Preserve keys
$data = ["a" => 1, "b" => 2, "c" => 3, "d" => 4];
$preserved = array_chunk($data, 2, true);
echo "\nWith preserved keys: ";
print_r($preserved);

// Uneven chunks
$items = ["apple", "banana", "cherry", "date", "elderberry"];
$groups = array_chunk($items, 2);
echo "\nUneven chunks: ";
print_r($groups);
?>