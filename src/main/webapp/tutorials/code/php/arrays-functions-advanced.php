<?php
// PHP Array Functions II - Modifying Arrays
// 8gwifi.org/tutorials

echo "=== Adding Elements ===\n";

// array_push - Add to end
$fruits = ["Apple", "Banana"];
array_push($fruits, "Cherry", "Date");
echo "After array_push: ";
print_r($fruits);

// array_unshift - Add to beginning
array_unshift($fruits, "Apricot");
echo "After array_unshift: ";
print_r($fruits);

echo "\n=== Removing Elements ===\n";

// array_pop - Remove from end
$colors = ["Red", "Green", "Blue", "Yellow"];
$removed = array_pop($colors);
echo "Popped: $removed\n";
echo "Remaining: " . implode(", ", $colors) . "\n";

// array_shift - Remove from beginning
$first = array_shift($colors);
echo "Shifted: $first\n";
echo "Remaining: " . implode(", ", $colors) . "\n";

echo "\n=== Merging Arrays ===\n";

$arr1 = ["a", "b", "c"];
$arr2 = ["d", "e", "f"];
$merged = array_merge($arr1, $arr2);
echo "array_merge: " . implode(", ", $merged) . "\n";

// Merging associative arrays
$defaults = ["color" => "red", "size" => "medium", "qty" => 1];
$options = ["size" => "large", "name" => "Widget"];
$config = array_merge($defaults, $options);
echo "Merged config: ";
print_r($config);

// Spread operator (PHP 7.4+)
$all = [...$arr1, "x", ...$arr2];
echo "Spread operator: " . implode(", ", $all) . "\n";

echo "\n=== array_combine ===\n";

$keys = ["name", "email", "age"];
$values = ["John", "john@test.com", 30];
$person = array_combine($keys, $values);
print_r($person);

echo "\n=== Slicing Arrays ===\n";

$numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

// array_slice(array, offset, length)
echo "slice(2, 4): " . implode(", ", array_slice($numbers, 2, 4)) . "\n";
echo "slice(-3): " . implode(", ", array_slice($numbers, -3)) . "\n";
echo "slice(0, -2): " . implode(", ", array_slice($numbers, 0, -2)) . "\n";

echo "\n=== array_splice ===\n";

$letters = ["a", "b", "c", "d", "e"];
echo "Original: " . implode(", ", $letters) . "\n";

// Remove 2 elements starting at index 1
$removed = array_splice($letters, 1, 2);
echo "Removed: " . implode(", ", $removed) . "\n";
echo "After splice: " . implode(", ", $letters) . "\n";

// Insert elements
$letters = ["a", "b", "e"];
array_splice($letters, 2, 0, ["c", "d"]);
echo "After insert: " . implode(", ", $letters) . "\n";

echo "\n=== array_flip and array_reverse ===\n";

$assoc = ["a" => 1, "b" => 2, "c" => 3];
echo "Original: ";
print_r($assoc);

echo "Flipped: ";
print_r(array_flip($assoc));

echo "Reversed: ";
print_r(array_reverse($assoc));

echo "\n=== array_chunk ===\n";

$items = range(1, 10);
$chunks = array_chunk($items, 3);
echo "Chunked into groups of 3:\n";
print_r($chunks);
?>
