<?php
// PHP random_int() - Cryptographically secure random integers

// Dice roll (1-6)
$dice = random_int(1, 6);
echo "Dice roll: $dice\n";

// 6-digit OTP
$otp = random_int(100000, 999999);
echo "OTP Code: $otp\n";

// 4-digit PIN
$pin = random_int(1000, 9999);
echo "PIN: $pin\n";

// Random percentage (0-100)
$percent = random_int(0, 100);
echo "Random %: $percent%\n";

// Generate multiple secure random numbers
echo "\n5 lottery numbers (1-49):\n";
$numbers = [];
while (count($numbers) < 5) {
    $n = random_int(1, 49);
    if (!in_array($n, $numbers)) {
        $numbers[] = $n;
    }
}
sort($numbers);
echo implode(", ", $numbers);
?>
