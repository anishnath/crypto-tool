<?php
// Split string into array
$str = "apple,banana,cherry";
$fruits = explode(",", $str);
print_r($fruits);

// Split with limit
$str = "one-two-three-four";
$parts = explode("-", $str, 2);
print_r($parts);  // ["one", "two-three-four"]

// Split by space
$sentence = "Hello World PHP";
$words = explode(" ", $sentence);
print_r($words);
?>
