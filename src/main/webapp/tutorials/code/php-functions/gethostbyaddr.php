<?php
// PHP gethostbyaddr() - Reverse DNS lookup

// Get hostname from IP address
$ip = '8.8.8.8';
$hostname = gethostbyaddr($ip);
echo "IP: $ip\n";
echo "Hostname: $hostname\n\n";

// Try another IP
$ip2 = '1.1.1.1';
$hostname2 = gethostbyaddr($ip2);
echo "IP: $ip2\n";
echo "Hostname: $hostname2\n\n";

// localhost
$local = gethostbyaddr('127.0.0.1');
echo "127.0.0.1 -> $local";
?>
