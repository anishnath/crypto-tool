<?php
// PHP http_build_query() - Build URL query string

// Simple array
$params = [
    'name' => 'John Doe',
    'age' => 30,
    'city' => 'New York'
];
$query = http_build_query($params);
echo "Simple: $query\n\n";

// Nested array
$data = [
    'user' => ['name' => 'John', 'email' => 'john@example.com'],
    'page' => 1
];
$nested = http_build_query($data);
echo "Nested: $nested\n\n";

// Array values
$filters = [
    'colors' => ['red', 'blue', 'green'],
    'size' => 'large'
];
$arrayQuery = http_build_query($filters);
echo "Array values: $arrayQuery\n\n";

// Build full URL
$baseUrl = "https://api.example.com/search";
$searchParams = ['q' => 'PHP tutorial', 'limit' => 10];
$fullUrl = $baseUrl . '?' . http_build_query($searchParams);
echo "Full URL: $fullUrl";
?>
