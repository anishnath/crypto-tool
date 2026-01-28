<?php
// PHP long2ip() - Integer to IP address

// Convert integers to IP addresses
$longs = [
    0,
    2130706433,    // 127.0.0.1
    3232235777,    // 192.168.1.1
    167772161,     // 10.0.0.1
    4294967295,    // 255.255.255.255
];

echo "Integer to IP Address Conversion:\n";
echo "==================================\n";

foreach ($longs as $long) {
    $ip = long2ip($long);
    echo "$long -> $ip\n";
}

// Round-trip conversion
echo "\nRound-trip Test:\n";
$original = '172.16.0.100';
$asLong = ip2long($original);
$backToIp = long2ip($asLong);
echo "Original: $original\n";
echo "As long: $asLong\n";
echo "Back to IP: $backToIp\n";
echo "Match: " . ($original === $backToIp ? 'Yes' : 'No');
?>
