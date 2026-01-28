<?php
// PHP password_verify() - Verify password against hash

$password = "my_secure_password";

// Create hash (normally stored in database)
$storedHash = password_hash($password, PASSWORD_DEFAULT);
echo "Stored Hash: $storedHash\n\n";

// Verify correct password
if (password_verify($password, $storedHash)) {
    echo "Correct password: VALID\n";
} else {
    echo "Correct password: INVALID\n";
}

// Verify wrong password
$wrongPassword = "wrong_password";
if (password_verify($wrongPassword, $storedHash)) {
    echo "Wrong password: VALID\n";
} else {
    echo "Wrong password: INVALID\n";
}
?>
