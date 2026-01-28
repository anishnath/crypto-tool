<?php
// PHP rawurldecode() - Decode URL-encoded strings

$encoded = "hello%20world";
echo "Encoded: $encoded\n";
echo "rawurldecode: " . rawurldecode($encoded) . "\n\n";

// Does NOT decode + to space
$withPlus = "hello+world";
echo "With plus: $withPlus\n";
echo "rawurldecode: " . rawurldecode($withPlus) . " (+ stays)\n";
echo "urldecode:    " . urldecode($withPlus) . " (+ becomes space)\n\n";

// Path decoding
$path = "/files/my%20document.pdf";
echo "Path: $path\n";
echo "Decoded: " . rawurldecode($path) . "\n\n";

// Special characters
$special = "test%26value%3D123";
echo "Special: $special\n";
echo "Decoded: " . rawurldecode($special);
?>
