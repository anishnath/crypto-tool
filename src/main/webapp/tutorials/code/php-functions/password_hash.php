<?php
// PHP password_hash() - Secure password hashing

$password = "my_secure_password";

// Using PASSWORD_DEFAULT (currently bcrypt)
$hash = password_hash($password, PASSWORD_DEFAULT);
echo "Hash: $hash\n";
echo "Length: " . strlen($hash) . " chars\n\n";

// With custom cost (default is 10)
$options = ['cost' => 12];
$hash2 = password_hash($password, PASSWORD_BCRYPT, $options);
echo "Higher cost: $hash2\n\n";

// Each call generates different hash (due to random salt)
$hash3 = password_hash($password, PASSWORD_DEFAULT);
echo "Different salt: $hash3\n\n";

echo "Note: Same password, different hashes - this is correct!";
?>
