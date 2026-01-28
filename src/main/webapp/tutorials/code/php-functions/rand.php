<?php
// Random integer
echo rand();      // Large random number
echo "\n";

// Random in range
echo rand(1, 10);   // 1 to 10
echo rand(1, 100);  // 1 to 100
echo "\n";

// Generate random string
$chars = 'abcdefghijklmnopqrstuvwxyz';
$code = '';
for ($i = 0; $i < 6; $i++) {
    $code .= $chars[rand(0, strlen($chars) - 1)];
}
echo "Code: $code\n";

// mt_rand is faster
echo mt_rand(1, 100);
?>
