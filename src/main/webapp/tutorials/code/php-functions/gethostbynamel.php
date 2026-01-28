<?php
// PHP gethostbynamel() - Get all IP addresses

// Get all IPs for a hostname
$host = 'www.google.com';
$ips = gethostbynamel($host);

echo "All IP addresses for $host:\n";
echo "=============================\n";
if ($ips !== false) {
    foreach ($ips as $ip) {
        echo "  - $ip\n";
    }
} else {
    echo "  No records found\n";
}

// Compare with single result
echo "\nSingle IP (gethostbyname): " . gethostbyname($host);
?>
