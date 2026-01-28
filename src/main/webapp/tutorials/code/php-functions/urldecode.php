<?php
// PHP urldecode() - URL decode string

$encoded = "hello+world";
echo "Encoded: $encoded\n";
echo "Decoded: " . urldecode($encoded) . "\n\n";

// Special characters
$special = "name%3DJohn%26age%3D30";
echo "Special: $special\n";
echo "Decoded: " . urldecode($special) . "\n\n";

// URL query string
$query = "search%3DPHP+%26+MySQL";
echo "Query: $query\n";
echo "Decoded: " . urldecode($query) . "\n\n";

// Note: + becomes space
echo "urldecode('a+b'):    '" . urldecode('a+b') . "'\n";
echo "rawurldecode('a+b'): '" . rawurldecode('a+b') . "'";
?>
