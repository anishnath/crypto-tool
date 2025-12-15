<?php
// Advanced Array Functions

$numbers = [1, 2, 3, 4, 5];

// Map - transform each element
$squared = array_map(function ($n) {
    return $n * $n;
}, $numbers);
print_r($squared);  // [1, 4, 9, 16, 25]
echo "\n";

// Filter - keep elements that match condition
$evens = array_filter($numbers, function ($n) {
    return $n % 2 == 0;
});
print_r($evens);  // [2, 4]
echo "\n";

// Reduce - combine all elements into single value
$sum = array_reduce($numbers, function ($carry, $n) {
    return $carry + $n;
}, 0);
echo "Sum: " . $sum;  // 15
echo "\n";

// Merge arrays
$arr1 = ["a", "b"];
$arr2 = ["c", "d"];
$merged = array_merge($arr1, $arr2);
print_r($merged);
echo "\n";

// Slice - extract portion
$slice = array_slice($numbers, 1, 3);
print_r($slice);  // [2, 3, 4]
echo "\n";

// Chunk - split into chunks
$chunks = array_chunk($numbers, 2);
print_r($chunks);  // [[1,2], [3,4], [5]]
