<?php
// PHP hash_equals() - Timing attack safe string comparison

$secretToken = "abc123xyz";
$expectedHash = hash('sha256', $secretToken);

// Simulate user input
$userToken = "abc123xyz";
$userHash = hash('sha256', $userToken);

// SECURE: Constant-time comparison
if (hash_equals($expectedHash, $userHash)) {
    echo "Token is VALID (secure comparison)\n";
} else {
    echo "Token is INVALID\n";
}

// Demonstrate with different values
$wrongHash = hash('sha256', 'wrong_token');
if (hash_equals($expectedHash, $wrongHash)) {
    echo "Should not see this\n";
} else {
    echo "Wrong token rejected (secure comparison)\n";
}
?>
