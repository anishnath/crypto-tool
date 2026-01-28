<?php
// PHP ip2long() - IP address to integer

// Convert IP addresses to integers
$ips = [
    '0.0.0.0',
    '127.0.0.1',
    '192.168.1.1',
    '10.0.0.1',
    '255.255.255.255',
];

echo "IP Address to Integer Conversion:\n";
echo "==================================\n";

foreach ($ips as $ip) {
    $long = ip2long($ip);
    echo "$ip -> $long\n";
}

// IP range check example
echo "\nIP Range Check Example:\n";
$testIp = ip2long('192.168.1.50');
$rangeStart = ip2long('192.168.1.0');
$rangeEnd = ip2long('192.168.1.255');

if ($testIp >= $rangeStart && $testIp <= $rangeEnd) {
    echo "192.168.1.50 is within 192.168.1.0/24";
}
?>
