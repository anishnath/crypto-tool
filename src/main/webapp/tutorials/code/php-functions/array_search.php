<?php
// Find key of value
$fruits = ["apple", "banana", "cherry"];
$key = array_search("banana", $fruits);
echo "Key: $key\n";  // 1

// Search in associative array
$ages = ["John" => 25, "Jane" => 30, "Bob" => 25];
$name = array_search(30, $ages);
echo "Name: $name\n";  // "Jane"

// Not found returns false
$result = array_search("grape", $fruits);
var_dump($result);  // bool(false)
?>
