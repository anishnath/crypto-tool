<?php
// Check valid UTF-8
$valid_utf8 = "Hello 世界";
$is_valid = mb_check_encoding($valid_utf8, 'UTF-8');
echo "Text: " . $valid_utf8 . "\n";
echo "Valid UTF-8: " . ($is_valid ? "Yes" : "No") . "\n\n";

// Check current encoding
$text = "Café français";
$check = mb_check_encoding($text);
echo "Text: " . $text . "\n";
echo "Valid for current encoding: " . ($check ? "Yes" : "No") . "\n\n";

// Array validation
$array = ["Hello", "世界", "Test"];
$valid_array = mb_check_encoding($array, 'UTF-8');
echo "Array validation: " . ($valid_array ? "All valid" : "Invalid") . "\n";
?>