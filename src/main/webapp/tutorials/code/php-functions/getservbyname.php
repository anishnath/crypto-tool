<?php
// PHP getservbyname() - Service to port lookup

// Common services
$services = [
    ['http', 'tcp'],
    ['https', 'tcp'],
    ['ftp', 'tcp'],
    ['ssh', 'tcp'],
    ['smtp', 'tcp'],
    ['domain', 'udp'],
    ['mysql', 'tcp'],
];

echo "Service to Port Mapping:\n";
echo "========================\n";

foreach ($services as [$service, $protocol]) {
    $port = getservbyname($service, $protocol);
    if ($port !== false) {
        echo "$service/$protocol -> Port $port\n";
    } else {
        echo "$service/$protocol -> Not found\n";
    }
}
?>
