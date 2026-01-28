<?php
// PHP random_bytes() - Cryptographically secure random bytes

// Generate 16 bytes (128 bits) - good for tokens
$token = random_bytes(16);
echo "Token (hex): " . bin2hex($token) . "\n";

// Generate 32 bytes (256 bits) - good for encryption keys
$key = random_bytes(32);
echo "Key (hex): " . bin2hex($key) . "\n";

// Generate salt for password hashing
$salt = random_bytes(16);
echo "Salt (hex): " . bin2hex($salt) . "\n";

// URL-safe token using base64
$urlToken = rtrim(strtr(base64_encode(random_bytes(16)), '+/', '-_'), '=');
echo "URL-safe Token: $urlToken\n";

// Generate API key
$apiKey = bin2hex(random_bytes(20));
echo "API Key: $apiKey";
?>
