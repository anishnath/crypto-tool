<?php
// Increment and Decrement Operators

$x = 5;

// Pre-increment (increment first, then return)
echo "Pre-increment: " . (++$x);  // 6
echo " (x is now: " . $x . ")";
echo "\n";

// Post-increment (return first, then increment)
$x = 5;
echo "Post-increment: " . ($x++);  // 5
echo " (x is now: " . $x . ")";
echo "\n";

// Pre-decrement
$x = 5;
echo "Pre-decrement: " . (--$x);  // 4
echo " (x is now: " . $x . ")";
echo "\n";

// Post-decrement
$x = 5;
echo "Post-decrement: " . ($x--);  // 5
echo " (x is now: " . $x . ")";
echo "\n";

// Common use in loops
for ($i = 0; $i < 5; $i++) {
    echo $i . " ";
}
