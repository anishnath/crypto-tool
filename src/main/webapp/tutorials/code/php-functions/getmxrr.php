<?php
// PHP getmxrr() - Get MX records

// Get MX records for a domain
$domain = 'gmail.com';
$hosts = [];
$weights = [];

echo "MX Records for $domain:\n";
echo "=======================\n";

if (getmxrr($domain, $hosts, $weights)) {
    // Sort by weight (priority)
    array_multisort($weights, SORT_ASC, $hosts);

    for ($i = 0; $i < count($hosts); $i++) {
        echo "Priority $weights[$i]: $hosts[$i]\n";
    }
} else {
    echo "No MX records found\n";
}
?>
