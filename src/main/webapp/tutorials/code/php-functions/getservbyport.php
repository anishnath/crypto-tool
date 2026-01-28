<?php
// PHP getservbyport() - Port to service lookup

// Common ports
$ports = [
    [21, 'tcp'],
    [22, 'tcp'],
    [25, 'tcp'],
    [53, 'udp'],
    [80, 'tcp'],
    [443, 'tcp'],
    [3306, 'tcp'],
    [8080, 'tcp'],
];

echo "Port to Service Mapping:\n";
echo "========================\n";

foreach ($ports as [$port, $protocol]) {
    $service = getservbyport($port, $protocol);
    if ($service !== false) {
        echo "Port $port/$protocol -> $service\n";
    } else {
        echo "Port $port/$protocol -> Unknown\n";
    }
}
?>
