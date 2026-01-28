<?php
// PHP hash_hmac_algos() - List algorithms suitable for HMAC

$hmacAlgos = hash_hmac_algos();
$allAlgos = hash_algos();

echo "HMAC-compatible algorithms: " . count($hmacAlgos) . "\n";
echo "All hash algorithms: " . count($allAlgos) . "\n\n";

echo "Common HMAC algorithms:\n";
$common = ['md5', 'sha1', 'sha256', 'sha384', 'sha512', 'sha3-256'];
foreach ($common as $algo) {
    $status = in_array($algo, $hmacAlgos) ? "supported" : "not supported";
    echo "- $algo: $status\n";
}
?>
