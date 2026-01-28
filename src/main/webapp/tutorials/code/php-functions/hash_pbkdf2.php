<?php
// PHP hash_pbkdf2() - PBKDF2 key derivation

$password = "user_password_123";
$salt = "random_salt_value"; // Use random_bytes(16) in production
$iterations = 100000; // Minimum recommended

// Derive 32-byte key (256 bits)
$key = hash_pbkdf2('sha256', $password, $salt, $iterations, 32);
echo "Derived Key (hex): $key\n";
echo "Key Length: " . strlen($key) . " hex chars = " . (strlen($key) / 2) . " bytes\n\n";

// Binary output
$keyBinary = hash_pbkdf2('sha256', $password, $salt, $iterations, 32, true);
echo "Binary (hex): " . bin2hex($keyBinary) . "\n";

// Different iterations = different key
$key2 = hash_pbkdf2('sha256', $password, $salt, 50000, 32);
echo "\nWith 50k iterations: $key2";
?>
