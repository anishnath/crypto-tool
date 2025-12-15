<?php
// Comparison Operators

$a = 10;
$b = "10";
$c = 20;

// Equal (loose comparison)
var_dump($a == $b);   // true (values are equal)
echo "\n";

// Identical (strict comparison)
var_dump($a === $b);  // false (different types)
echo "\n";

// Not equal
var_dump($a != $c);   // true
var_dump($a <> $c);   // true (alternative syntax)
echo "\n";

// Not identical
var_dump($a !== $b);  // true (different types)
echo "\n";

// Greater than
var_dump($c > $a);    // true
echo "\n";

// Less than
var_dump($a < $c);    // true
echo "\n";

// Greater than or equal
var_dump($a >= 10);   // true
echo "\n";

// Less than or equal
var_dump($a <= 10);   // true
echo "\n";

// Spaceship operator (PHP 7+)
echo $a <=> $b;  // 0 (equal)
echo "\n";
echo $a <=> $c;  // -1 (less than)
echo "\n";
echo $c <=> $a;  // 1 (greater than)
