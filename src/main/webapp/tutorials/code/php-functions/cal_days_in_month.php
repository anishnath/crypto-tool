<?php
$num = cal_days_in_month(CAL_GREGORIAN, 8, 2023); // 31
echo "There were {$num} days in August 2023\n";

$num2 = cal_days_in_month(CAL_GREGORIAN, 2, 2024); // 29 (Leap year)
echo "There were {$num2} days in Feb 2024\n";
?>