<?php
// PHP parse_url() - Parse URL components

$url = "https://user:pass@example.com:8080/path/page.php?q=test&lang=en#section";

echo "URL: $url\n\n";

// Get all components
$parts = parse_url($url);
echo "All components:\n";
print_r($parts);

// Get specific components
echo "\nSpecific components:\n";
echo "Scheme: " . parse_url($url, PHP_URL_SCHEME) . "\n";
echo "Host: " . parse_url($url, PHP_URL_HOST) . "\n";
echo "Port: " . parse_url($url, PHP_URL_PORT) . "\n";
echo "Path: " . parse_url($url, PHP_URL_PATH) . "\n";
echo "Query: " . parse_url($url, PHP_URL_QUERY) . "\n";
echo "Fragment: " . parse_url($url, PHP_URL_FRAGMENT) . "\n";

// Parse query string
parse_str(parse_url($url, PHP_URL_QUERY), $queryParams);
echo "\nQuery parameters:\n";
print_r($queryParams);
?>
