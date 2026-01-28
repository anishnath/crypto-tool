<?php
// PHP password_needs_rehash() - Check if hash needs upgrade

$password = "user_password";

// Old hash with cost=10
$oldHash = password_hash($password, PASSWORD_BCRYPT, ['cost' => 10]);
echo "Old hash (cost=10): " . substr($oldHash, 0, 30) . "...\n";

// Check if needs rehash with cost=12
$newOptions = ['cost' => 12];
if (password_needs_rehash($oldHash, PASSWORD_BCRYPT, $newOptions)) {
    echo "Needs rehash: YES\n";

    // On successful login, rehash
    $newHash = password_hash($password, PASSWORD_BCRYPT, $newOptions);
    echo "New hash (cost=12): " . substr($newHash, 0, 30) . "...\n";
} else {
    echo "Needs rehash: NO\n";
}

// Check against same options
$sameHash = password_hash($password, PASSWORD_BCRYPT, ['cost' => 10]);
if (password_needs_rehash($sameHash, PASSWORD_BCRYPT, ['cost' => 10])) {
    echo "\nSame cost needs rehash: YES\n";
} else {
    echo "\nSame cost needs rehash: NO\n";
}
?>
