<?php
// PHP hash_hmac() - Generate keyed hash (HMAC)

$secretKey = "my-secret-key-123";
$message = "Hello World";

// HMAC-SHA256 (most common)
$signature = hash_hmac('sha256', $message, $secretKey);
echo "HMAC-SHA256: $signature\n";

// HMAC-SHA512 (stronger)
$signature512 = hash_hmac('sha512', $message, $secretKey);
echo "HMAC-SHA512: $signature512\n";

// Verify signature
$receivedMessage = "Hello World";
$receivedSignature = $signature;
$expectedSignature = hash_hmac('sha256', $receivedMessage, $secretKey);

if (hash_equals($expectedSignature, $receivedSignature)) {
    echo "\nSignature VALID - message is authentic";
}
?>
