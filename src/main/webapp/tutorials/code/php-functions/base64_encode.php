<?php
// PHP base64_encode() - Encode to Base64

// Simple text
$text = "Hello World";
$encoded = base64_encode($text);
echo "Original: $text\n";
echo "Base64: $encoded\n\n";

// Binary data (simulate)
$binary = "\x00\x01\x02\xFF\xFE";
echo "Binary (hex): " . bin2hex($binary) . "\n";
echo "Base64: " . base64_encode($binary) . "\n\n";

// JSON data
$data = ['name' => 'John', 'age' => 30];
$json = json_encode($data);
echo "JSON: $json\n";
echo "Base64: " . base64_encode($json) . "\n\n";

// Data URI example
$svg = '<svg><circle r="10"/></svg>';
$dataUri = 'data:image/svg+xml;base64,' . base64_encode($svg);
echo "Data URI: " . substr($dataUri, 0, 50) . "...";
?>
