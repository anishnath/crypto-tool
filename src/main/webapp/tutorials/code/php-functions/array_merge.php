<?php
// Merge two arrays
$a = [1, 2, 3];
$b = [4, 5, 6];
$merged = array_merge($a, $b);
print_r($merged);  // [1, 2, 3, 4, 5, 6]

// Merge associative arrays
$defaults = ["color" => "red", "size" => "M"];
$custom = ["color" => "blue"];
$result = array_merge($defaults, $custom);
print_r($result);  // ["color" => "blue", "size" => "M"]
?>
