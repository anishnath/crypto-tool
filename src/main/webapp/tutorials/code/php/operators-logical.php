<?php
// Logical Operators

$a = true;
$b = false;

// AND (both must be true)
var_dump($a && $b);   // false
var_dump($a and $b);  // false (lower precedence)
echo "\n";

// OR (at least one must be true)
var_dump($a || $b);   // true
var_dump($a or $b);   // true (lower precedence)
echo "\n";

// NOT (inverts boolean)
var_dump(!$a);        // false
var_dump(!$b);        // true
echo "\n";

// XOR (exactly one must be true)
var_dump($a xor $b);  // true
var_dump($a xor $a);  // false
echo "\n";

// Practical example
$age = 25;
$hasLicense = true;

if ($age >= 18 && $hasLicense) {
    echo "Can drive!";
}
