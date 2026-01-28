<?php
// Read entire file
$content = file_get_contents("example.txt");
echo $content;

// Read from URL (if allowed)
// $html = file_get_contents("https://example.com");

// With context (headers, etc.)
$opts = [
    "http" => [
        "method" => "GET",
        "header" => "Accept: application/json"
    ]
];
$context = stream_context_create($opts);
// $response = file_get_contents($url, false, $context);

// Check if file exists first
$file = "config.json";
if (file_exists($file)) {
    $config = json_decode(file_get_contents($file), true);
    print_r($config);
}
?>
