<?php
// Locale-based formatting
setlocale(LC_TIME, 'en_US', 'en_US.utf8');

echo strftime("%B %d, %Y, %H:%M") . "\n"; // December 25, 2025, 14:30
echo strftime("%A"); // Thursday
?>