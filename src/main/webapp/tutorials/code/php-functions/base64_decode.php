<?php
// PHP base64_decode() - Decode Base64

// Simple decode
$encoded = "SGVsbG8gV29ybGQ=";
$decoded = base64_decode($encoded);
echo "Base64: $encoded\n";
echo "Decoded: $decoded\n\n";

// JSON payload (common in APIs, JWTs)
$base64Json = "eyJuYW1lIjoiSm9obiIsImFnZSI6MzB9";
$json = base64_decode($base64Json);
echo "Base64 JSON: $base64Json\n";
echo "Decoded: $json\n";
$data = json_decode($json, true);
echo "Name: " . $data['name'] . "\n\n";

// Strict mode
$invalid = "Invalid!!Base64";
$result = base64_decode($invalid, true);
if ($result === false) {
    echo "Strict mode: Invalid base64 detected\n";
}

// Without strict mode (may return garbage)
$result2 = base64_decode($invalid, false);
echo "Non-strict: returned " . strlen($result2) . " bytes";
?>
