<?php
// PHP preg_split() - Split string by regex

// Split by multiple delimiters
$text = "apple, banana; cherry orange";
$fruits = preg_split('/[\s,;]+/', $text);
echo "Fruits:\n";
print_r($fruits);

// Split into words
$sentence = "Hello World PHP";
$words = preg_split('/\s+/', $sentence);
echo "Words:\n";
print_r($words);

// Split into characters
$str = "hello";
$chars = preg_split('//', $str, -1, PREG_SPLIT_NO_EMPTY);
echo "Characters:\n";
print_r($chars);

// Keep delimiters
$math = "10+20-5*2";
$parts = preg_split('/([+\-*\/])/', $math, -1, PREG_SPLIT_DELIM_CAPTURE);
echo "Math parts:\n";
print_r($parts);
?>
