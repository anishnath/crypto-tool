<?php
// PHP password_algos() - List available password algorithms

$algos = password_algos();

echo "Available password hashing algorithms:\n";
echo "======================================\n\n";

foreach ($algos as $algo) {
    echo "- $algo\n";
}

echo "\nTotal: " . count($algos) . " algorithms\n\n";

// Common algorithms:
// 2y = bcrypt
// argon2i = Argon2i
// argon2id = Argon2id (recommended)
?>
