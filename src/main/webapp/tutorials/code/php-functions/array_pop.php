<?php
// Remove and return last element
$stack = ["a", "b", "c", "d"];
$last = array_pop($stack);
echo "Popped: $last\n";  // "d"
print_r($stack);  // ["a", "b", "c"]

// Use as stack
$stack = [];
array_push($stack, "first");
array_push($stack, "second");
echo array_pop($stack);  // "second" (LIFO)
?>
