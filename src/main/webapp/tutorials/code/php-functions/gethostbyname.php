<?php
// PHP gethostbyname() - DNS lookup

// Get IP address from hostname
$host = 'www.google.com';
$ip = gethostbyname($host);
echo "Hostname: $host\n";
echo "IP: $ip\n\n";

// Try another hostname
$host2 = 'dns.google';
$ip2 = gethostbyname($host2);
echo "Hostname: $host2\n";
echo "IP: $ip2\n\n";

// localhost
$local = gethostbyname('localhost');
echo "localhost -> $local";
?>
