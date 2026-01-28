<?php
// PHP password_get_info() - Get information about a hash

$password = "test_password";

// Create bcrypt hash
$bcryptHash = password_hash($password, PASSWORD_BCRYPT);
$info = password_get_info($bcryptHash);

echo "Hash: $bcryptHash\n\n";
echo "Algorithm Info:\n";
echo "- algo: " . $info['algo'] . "\n";
echo "- algoName: " . $info['algoName'] . "\n";
echo "- options: ";
print_r($info['options']);

// With custom cost
echo "\nWith cost=12:\n";
$hash2 = password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
$info2 = password_get_info($hash2);
echo "- options: ";
print_r($info2['options']);
?>
