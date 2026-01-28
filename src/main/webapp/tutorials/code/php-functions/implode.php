<?php
// Join array into string
$fruits = ["apple", "banana", "cherry"];
echo implode(", ", $fruits);  // "apple, banana, cherry"
echo "\n";

// Join with different separators
$words = ["Hello", "World"];
echo implode(" ", $words);    // "Hello World"
echo "\n";
echo implode("-", $words);    // "Hello-World"
echo "\n";

// Empty separator
$chars = ["H", "e", "l", "l", "o"];
echo implode("", $chars);     // "Hello"
?>
