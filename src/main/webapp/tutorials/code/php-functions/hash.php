<?php
// PHP hash() - Generate hash value (message digest)

$data = "Hello World";

// MD5 (legacy, not for security)
echo "MD5: " . hash('md5', $data) . "\n";

// SHA-256 (recommended)
echo "SHA-256: " . hash('sha256', $data) . "\n";

// SHA-512
echo "SHA-512: " . hash('sha512', $data) . "\n";

// SHA3-256
echo "SHA3-256: " . hash('sha3-256', $data) . "\n";

// Binary output (raw bytes)
$binary = hash('sha256', $data, true);
echo "Binary (hex): " . bin2hex($binary) . "\n";
?>
