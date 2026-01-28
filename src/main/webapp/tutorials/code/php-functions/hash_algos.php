<?php
// PHP hash_algos() - List all registered hashing algorithms

$algos = hash_algos();

echo "Total algorithms: " . count($algos) . "\n\n";

// Show first 20 algorithms
echo "Available algorithms:\n";
foreach (array_slice($algos, 0, 20) as $algo) {
    echo "- $algo\n";
}
echo "... and more\n\n";

// Check specific algorithm
if (in_array('sha256', $algos)) {
    echo "SHA-256 is supported";
}
?>
