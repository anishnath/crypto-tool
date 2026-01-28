<?php
// PHP rawurlencode() - RFC 3986 URL encoding

$text = "hello world";
echo "Original: $text\n";
echo "rawurlencode: " . rawurlencode($text) . "\n";
echo "urlencode:    " . urlencode($text) . "\n\n";

// Key difference: spaces
echo "Space encoding comparison:\n";
echo "rawurlencode(' '): " . rawurlencode(' ') . " (percent-encoded)\n";
echo "urlencode(' '):    " . urlencode(' ') . " (plus sign)\n\n";

// Use for URL paths
$filename = "my document.pdf";
$path = "/files/" . rawurlencode($filename);
echo "Path: $path\n\n";

// Path with special chars
$folder = "2024/Q1 Report (Final)";
echo "Folder encoded: " . rawurlencode($folder);
?>
