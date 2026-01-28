<?php
// PHP hash_hkdf() - HKDF key derivation (RFC 5869)

// Input key material (normally from key exchange or random_bytes)
$inputKey = "shared_secret_key_material";

// Derive encryption key
$encryptionKey = hash_hkdf('sha256', $inputKey, 32, 'encryption');
echo "Encryption Key: " . bin2hex($encryptionKey) . "\n";

// Derive authentication key (different info = different key)
$authKey = hash_hkdf('sha256', $inputKey, 32, 'authentication');
echo "Auth Key: " . bin2hex($authKey) . "\n";

// With salt for added security
$salt = "random_salt_value";
$derivedKey = hash_hkdf('sha256', $inputKey, 32, 'app_key', $salt);
echo "With Salt: " . bin2hex($derivedKey) . "\n";
?>
