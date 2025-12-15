<?php
// Explicit Type Casting

// Cast to integer
$float = 9.99;
$int = (int) $float;
echo "Float to Int: " . $int;  // Output: 9
echo "\n";

// Cast to float
$integer = 42;
$decimal = (float) $integer;
echo "Int to Float: " . $decimal;  // Output: 42.0
echo "\n";

// Cast to string
$number = 123;
$text = (string) $number;
echo "Number to String: " . $text;
echo "\n";

// Cast to boolean
$zero = 0;
$bool = (bool) $zero;
echo "Zero to Boolean: ";
var_dump($bool);  // Output: bool(false)
echo "\n";

// Cast to array
$value = "hello";
$arr = (array) $value;
echo "String to Array: ";
var_dump($arr);
