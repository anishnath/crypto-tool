<?php
// Assignment Operators

$x = 10;  // Simple assignment

// Addition assignment
$x += 5;  // Same as: $x = $x + 5
echo "After += 5: " . $x;  // 15
echo "\n";

// Subtraction assignment
$x -= 3;  // Same as: $x = $x - 3
echo "After -= 3: " . $x;  // 12
echo "\n";

// Multiplication assignment
$x *= 2;  // Same as: $x = $x * 2
echo "After *= 2: " . $x;  // 24
echo "\n";

// Division assignment
$x /= 4;  // Same as: $x = $x / 4
echo "After /= 4: " . $x;  // 6
echo "\n";

// Modulus assignment
$x %= 4;  // Same as: $x = $x % 4
echo "After %= 4: " . $x;  // 2
echo "\n";

// String concatenation assignment
$str = "Hello";
$str .= " World";  // Same as: $str = $str . " World"
echo $str;  // "Hello World"
