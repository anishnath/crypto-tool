<?php
// Type Juggling - PHP automatically converts types

// String to Number
$str = "123";
$num = $str + 10;  // PHP converts "123" to 123
echo "String + Number: " . $num;  // Output: 133
echo "\n";

// Number to String
$number = 42;
$text = "The answer is " . $number;  // 42 becomes "42"
echo $text;
echo "\n";

// Boolean to Number
$bool = true;
$result = $bool + 5;  // true becomes 1
echo "Boolean + Number: " . $result;  // Output: 6
echo "\n";

// Automatic conversion in comparisons
$a = "10";
$b = 10;
if ($a == $b) {  // Loose comparison - types are converted
    echo "10 == \"10\" is true (type juggling)";
}
