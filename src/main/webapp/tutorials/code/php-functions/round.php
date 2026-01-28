<?php
// Round to nearest integer
echo round(4.3);   // 4
echo round(4.7);   // 5
echo "\n";

// Round to decimal places
echo round(3.14159, 2);  // 3.14
echo round(3.14159, 3);  // 3.142
echo "\n";

// Rounding modes
echo round(2.5);                        // 3 (PHP_ROUND_HALF_UP)
echo round(2.5, 0, PHP_ROUND_HALF_DOWN); // 2
echo round(2.5, 0, PHP_ROUND_HALF_EVEN); // 2
?>
